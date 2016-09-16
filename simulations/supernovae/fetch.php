<?php
$supernovae = array('SN1991bg', 'SN1999ee', 'SN2011fe', 'SN2014J', 'SN2012fr', 'SN1998aq');

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
        @$entry['magnitude'] += $max_absmag - $max_appmag;
        $entry['time_since_maximum'] = (float)$entry['time'] - (float)$peak_time;
    }

    return $entries;
}


$curves = array();
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
}


foreach($curves as $SN => $curve)
{
    $fp = fopen("../../plots/data/{$SN}_lightcurve.res", "w+");
    foreach($curve['B'] as $datapoint) fwrite($fp, "{$datapoint['time_since_maximum']} {$datapoint['magnitude']}\n");
}
fclose($fp);
?>
