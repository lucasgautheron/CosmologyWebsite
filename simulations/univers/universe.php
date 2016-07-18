<?php
define('H_0', 1.0/14536650456.5);

function Friedmann($o_m0, $o_r0, $o_v0, $o_k0, $a0, $eta_0, $N)
{
    $d_eta = $eta_0/$N;
    $a[0] = $a0;
    $t[0] = 0;
   
    for($i = 0; $i < $N-1; ++$i)
    {
        $a[$i+1] = $a[$i] + $d_eta * sqrt($o_r0 + $o_m0*$a[$i] + $o_k0*$a[$i]*$a[$i] + $o_v0*$a[$i]*$a[$i]*$a[$i]*$a[$i]);
        $t[$i+1] = $t[$i] + $a[$i]*$d_eta;
    }
    return array($a, $t);
}

function lookup($val, $size, &$A)
{
    $dist = -1;
    $closest = -1;
    foreach($A as $i => $av)
    {
        if(abs($val-$av) < $dist || $closest < 0)
        {
            $dist = abs($val-$av);
            $closest = $i;
        }
    }
    return $closest;
}

function fast_lookup_rev($val, &$A)
{
    for($i = count($A)-1; $i > 0; --$i)
    {
        if($val > $A[$i]) return $i;
    }
    return 0;
}

function filter($A, $keep)
{
    $B = array();
    $ratio = round(100*$keep/count($A[0]))/100;
    $next = (int)(1/$ratio);
    for($i = 0; $i < count($A[0]); $i += $next)
    {
        $B[0][] = $A[0][$i];
        $B[1][] = $A[1][$i];
    }
    return $B;
}

$o_m0 = isset($_GET['m']) ? $_GET['m']/100.0 : 0.315;
$o_r0 = isset($_GET['r']) ? $_GET['r']/100.0 : 8.4e-5;
$o_v0 = isset($_GET['v']) ? $_GET['v']/100.0 : 0.685;
$a0 = isset($_GET['a0']) ? $_GET['a0'] : 0;
$o_k0 = 1-$o_m0-$o_r0-$o_v0;

$results = Friedmann($o_m0, $o_r0, $o_v0, $o_k0, $a0, 10, 200000);

$age = $results[1][fast_lookup_rev(1.0, $results[0])];
$age_ga = $age / H_0 / (1e9);
$points = filter($results, 1000);

$data = array('points' => $points, 'age' => $age, 'age_ga' => $age_ga);
echo json_encode($data);

?>
