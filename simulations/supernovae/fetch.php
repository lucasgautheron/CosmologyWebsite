<?php
$supernovae = array('SN1991bg', 'SN1999ee', 'SN2011fe', 'SN2012fr', 'SN1998aq', 'SN1971I', 'SN1980N', 'SN1981B', 'SN1986G', 'SN1989B', 'SN1990N', 'SN1991T', 'SN1992A', 'SN2000cx', 'SN1999ee', 'SN1998bu', 'SN2007af', 'SN2009dc', 'SN2004eo', 'SN1991T', 'SN2002bo');

function getlightcurve($data, $band)
{
    $max_absmag = $max_appmag = 0;

    foreach($data['maxband'] as $n => $b)
    {
        if($b['value'] == $band) // galactic absorption might be band dependent ?
        {
            $max_absmag = $data['maxabsmag'][$n]['value'];
            $max_appmag = $data['maxappmag'][$n]['value'];
        }
    }

    $entries = array();
    $peak_mag = 1000;
    $peak_time = 0;

    foreach($data['photometry'] as $entry)
    {
        if($entry['band'] == $band)
        {
            $entry['time'] = is_array($entry['time']) ? array_sum($entry['time'])/count($entry['time']) : $entry['time'];
            $entries[] = $entry;

            if($entry['magnitude'] < $peak_mag)
            {
                $peak_mag = $entry['magnitude'];
                $peak_time = $entry['time'];
            }
        }


    }

    foreach($entries as &$entry)
    {
        $entry['apparent_magnitude'] = $entry['magnitude'];
        @$entry['magnitude'] += $max_absmag - $max_appmag;
        $entry['time_since_maximum'] = (float)$entry['time'] - (float)$peak_time;
    }

    echo "max: {$peak_mag} {$max_appmag}\n";

    return $entries;
}


$curves = array();
$fp_deltam15= fopen("../../plots/data/SNIa_deltam15.res", "w+");

foreach($supernovae as $supernova)
{
    $json = "../../tmp/$supernova.json";
    if(!file_exists($json))
    {
        file_put_contents($json, file_get_contents("https://sne.space/sne/$supernova.json"));
    }

    $data = json_decode(file_get_contents($json), true);
    $data = $data[$supernova];

//print_r($data);

    $z = $data['redshift'];

    $curves[$supernova]['B'] = getlightcurve($data, 'B');
    $curve = $curves[$supernova];

    $fp = fopen("../../plots/data/{$supernova}_lightcurve.res", "w+");
    foreach($curve['B'] as $datapoint) fwrite($fp, "{$datapoint['time_since_maximum']} {$datapoint['magnitude']}\n");
    fclose($fp);

    $max_absmag = $max_appmag = 0;
    foreach($data['maxband'] as $n => $b)
    {
        if($b['value'] == 'B') // galactic absorption might be band dependent ?
        {
            $max_absmag = $data['maxabsmag'][$n]['value'];
            $max_appmag = $data['maxappmag'][$n]['value'];
        }
    }

    foreach($curve['B'] as $n => $datapoint)
    {
        if($datapoint['time_since_maximum'] >= 15)
        {
            $delta = $datapoint['apparent_magnitude'] - $max_appmag;
            $a = ($curve['B'][$n-1]['apparent_magnitude']-$curve['B'][$n]['apparent_magnitude'])/($curve['B'][$n]['time_since_maximum']-$curve['B'][$n-1]['time_since_maximum']);
            $b = $curve['B'][$n]['apparent_magnitude'];
            $delta_interpol = $a * ($curve['B'][$n]['time_since_maximum']-15) + $b - $max_appmag;
           
            fwrite($fp_deltam15, "$delta_interpol {$max_absmag} {$datapoint['time_since_maximum']} $supernova\n");
            
            break;
        }
    }

}
fclose($fp_deltam15);
?>
