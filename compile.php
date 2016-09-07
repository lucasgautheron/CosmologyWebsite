<?php
chdir(__DIR__);
$output = array();
$return_code = $return = 0;

$verbose = in_array('-V', $_SERVER['argv']);
$perform_simulations = in_array('-S', $_SERVER['argv']);
$archive = in_array('-A', $_SERVER['argv']);

$redirect = $verbose ? "" : " > /dev/null 2>&1 ";

function strip_decl($str)
{
    return str_replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n", '', $str);
}
// XML
$files[0] = strip_decl(file_get_contents("data/events.xml"));
$files[1] = strip_decl(file_get_contents("data/contents.xml"));
$files[2] = strip_decl(file_get_contents("data/appendices.xml"));

file_put_contents('tmp/cache.xml', "<?xml version=\"1.0\" encoding=\"UTF-8\"?><root>{$files[0]}{$files[1]}{$files[2]}</root>");

$start_time = microtime(true);
exec('saxonb-xslt -s:tmp/cache.xml -xsl:refs.xsl -o:tmp/refs -ext:on' . $redirect, $output, $return_code);
$return |= $return_code;

$refs = file('tmp/refs');
foreach($refs as $ref)
{
    $ref = trim($ref);
    if(strpos($ref, 'doi:') === 0)
    {
        $ref = substr($ref, strlen('doi:'));
        $safedoi = str_replace(')', '_', str_replace('(', '_', str_replace('/', '_', $ref)));
        $outfile = "tmp/ref_$safedoi.xml";
        if(!file_exists($outfile))
        {
            exec("curl --location --header \"Accept: application/unixref+xml\" \"http://dx.doi.org/$ref\" -o \"$outfile\" " . $redirect, $output, $return_code);
            $return |= $return_code;
        }
    }
    else if(strpos($ref, 'isbn:') === 0)
    {
        $ref = substr($ref, strlen('isbn:'));
        $isbn = $ref;
        $outfile = "tmp/ref_$isbn.xml";
        if(file_exists($outfile))
            continue;
            
        exec("basex -q 'let " . '$url' . " := \"https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn\" return json-to-xml(fetch:text(" . '$url' . "))' > $outfile");
    }
}
echo "REFS generation completed (" . round(microtime(true) - $start_time, 4) . " s)\n";

$start_time = microtime(true);
exec('saxonb-xslt -s:tmp/cache.xml -xsl:layout.xsl -o:index.html -ext:on' . $redirect, $output, $return_code);
$return |= $return_code;
echo "HTML generation completed (" . round(microtime(true) - $start_time, 4) . " s)\n";

$start_time = microtime(true);
exec('saxonb-xslt -s:tmp/cache.xml -xsl:graph.xsl -o:graph.html -ext:on' . $redirect, $output, $return_code);
$return |= $return_code;
echo "graph generation completed (" . round(microtime(true) - $start_time, 4) . " s)\n";

@unlink('tmp/cache.xml');
@unlink('tmp/refs');

// simulations
if($perform_simulations)
{
    $start_time = microtime(true);
    
    $simulations = glob('simulations/*', GLOB_ONLYDIR);
    
    foreach($simulations as $simulation)
    {
        if(!file_exists("$simulation/do.sh"))
        {
            if($verbose) echo "Skipped $simulation due to missing do.sh file\n";
            continue;
        }
        
        exec("tar -zcvf $simulation.tar.gz $simulation"); 
        
        if($verbose) echo "Running simulation $simulation...\n";
        
        chdir($simulation);
        
        chmod('do.sh', 0755);
        exec('./do.sh' . $redirect, $output, $return_code);
        $return |= $return_code;
        
        chdir('../..');
    }
    echo "simulations execution completed (" . round(microtime(true) - $start_time, 4) . " s)\n";
}

// gnuplot
$start_time = microtime(true);
chdir('plots/');
$plots = glob("*.gnuplot");
foreach($plots as $plot)
{
    $plot = preg_replace('/\\.(gnuplot)/', '', $plot);
    file_put_contents("tmp", "set term svg enhanced dynamic dashed font 'DejaVuSerif,14'; set out '../images/$plot.svg'; \n" . file_get_contents("$plot.gnuplot"));
    exec('gnuplot tmp' . $redirect, $output, $return_code);
    $return |= $return_code;
}
if(is_file('tmp')) unlink('tmp');

echo "plot generation completed (" . round(microtime(true) - $start_time, 4) . " s)\n";

chdir('..');

if($archive)
{
    @unlink('archive.tar.gz');
    exec("tar -zcvf ../archive.tar.gz . --exclude='*~' --exclude='.git' --exclude='tmp' --exclude='data'");
    rename('../archive.tar.gz', 'archive.tar.gz');
}

exit((int)$return);
