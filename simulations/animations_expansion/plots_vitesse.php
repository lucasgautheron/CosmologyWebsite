<?php
$type = $_SERVER['argv'][1];
$drop = $_SERVER['argv'][2];

if(!is_dir('files')) mkdir('files');

function ticks($min, $max, $count, $round)
{
    $delta = ($max-$min)/$count;
    $delta /= $round;
    $delta = ceil($delta);
    return $delta * $round;
}

$lines = file_get_contents("out_$type.res");

$data = array();
preg_match_all("#(.*) (.*) (.*) (.*) (.*)\n#u", $lines, $data);

$lines = array();

$x0 = 0;
$d = 0;
$t0 = 0;
foreach($data[0] as $n => $line)
{
    if($n == 0)
    {
        $t0 = $data[1][$n];
        $x0 = abs($data[2][$n]);
        $d = 2*$x0;
    }
    $lines[] = array($data[1][$n], $data[2][$n], $data[3][$n], $data[4][$n]);
    $max_ratio = 1+$data[4][$n];
    $max_time = $data[1][$n];
    $max_r = $data[3][$n];
    $max_dl = (1+$data[4][$n])*$data[3][$n];
    $max_v = $data[5][$n];
}

$k = 0;
foreach($lines as $n => $line)
{
    $skip = $n && $n < count($lines)-1 && ($n%$drop != 0);
    if($skip) continue;
    $index = sprintf("%06d", $k);
    $k++;
    $mid = 0;
    $min_x = $mid + (- 1.5) * $max_ratio / (1+$line[3]);
    $max_x = $mid + (+ 1.5) * $max_ratio / (1+$line[3]);
    $min_y = -0.5 * $max_ratio / (1+$line[3]);
    $max_y = 0.5 * $max_ratio / (1+$line[3]);
    //$code = "set term svg enhanced dynamic dashed font 'DejaVuSerif,14'; set out 'files/$index.svg'; \n";
    $code = "set term pngcairo enhanced font 'DejaVuSerif,14'  size 640,1024; set out 'files/$index.png';\n";
    $xtics = 0.5 * $max_ratio / 6;
    $xtics = round($xtics*10)/10;
    $code .= "set size 2,1
set multiplot layout 4, 1
";
    $code .= "
set title  sprintf(\"t=%.2f, z=%.2f\",{$line[0]}-$max_time,{$line[3]})
set lmargin at screen 0.1
set rmargin at screen 0.9
set bmargin at screen 0.7
set tmargin at screen 0.85

unset key
set xrange [ $min_x:$max_x ]
 set yrange [ $min_y : $max_y ]
set grid xtics ytics
set xtics $xtics
set xtics format ' '
set ytics format ' '
set ytics $xtics

set object 1 circle at first -1,0 size 0.05
set object 2 circle at first 1,0 size 0.05

plot 'out_$type.res' u ($2/$x0):($1 <= {$line[0]}+0.01 ? 0 : NaN) w l lt 1 lw 1.5
";

    $mid = $line[1]/$x0;
    $min_x = $mid + (- 1.5) * $max_ratio / (1+$line[3]);
    $max_x = $mid + (+ 1.5) * $max_ratio / (1+$line[3]);
    
    $code .= "
set lmargin at screen 0.1
set rmargin at screen 0.9
set bmargin at screen 0.5
set tmargin at screen 0.65
    
unset key
unset title
set xrange [ $min_x:$max_x ]
 set yrange [ $min_y : $max_y ]
set grid xtics ytics
set xtics $xtics
set xtics format ' '
set ytics format ' '
set ytics $xtics

set object 1 circle at first -1,0 size 0.05
set object 2 circle at first 1,0 size 0.05

plot 'out_$type.res' u ($2/$x0):($1 <= {$line[0]}+0.01 ? 0 : NaN) w l lt 1 lw 1.5
";
    
    $xtics = ticks($t0-$max_time, 0, 5, 0.25);
    $ytics = ticks(0, $max_r, 5, $max_r < 5 ? 1 : 25);
    $code .= "
    set lmargin at screen 0.1
set rmargin at screen 0.9
set bmargin at screen 0.3
set tmargin at screen 0.45


f(x) = x

    unset title
    unset key
    unset grid
    unset xtics
    unset ytics
    set xtics format ' '
    set ytics format '%.1f'
    unset object 1
    unset object 2
    set ytics 0,$ytics,$max_r
    set xtics $t0-$max_time,$xtics,0
    set xrange [ $t0-$max_time:0 ]
    set yrange [ 0:$max_r ]
plot 'out_$type.res' u ($1-$max_time):($1 <= {$line[0]}+0.01 ? ($3) : NaN) w l, x+($max_time-$t0)
";

    $xtics = ticks($t0-$max_time, 0, 5, 0.25);

    $ytics = ticks(0, $max_v, 5, 1);
    $code .= "
set lmargin at screen 0.1
set rmargin at screen 0.9
set bmargin at screen 0.1
set tmargin at screen 0.25

    unset title
    unset key
    unset grid
    unset xtics
    unset ytics
    set xtics format '%.1f'
    set ytics format '%.1f'
    unset object 1
    unset object 2
    set ytics 0,$ytics,$max_dl
    set xtics $t0-$max_time,$xtics,0
    set xrange [ $t0-$max_time:0 ]
    set yrange [ 0:$max_v ]
plot 'out_$type.res' u ($1-$max_time):( ($1 <= {$line[0]}+0.01 && $5 > 0.01) ? ($5) : NaN) w l, 1
";

    $code .= "
unset multiplot";
    file_put_contents('tmp', $code);
    exec('gnuplot tmp');
}
?>
