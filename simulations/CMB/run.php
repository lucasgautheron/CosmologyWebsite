<?php
function default_params()
{
    $params = array();
    $params['scalar_amp(1)'] = 2.1e-9;
    $params['scalar_spectral_index(1)'] = 0.96;

    $params['ombh2'] = 0.0226;
    $params['omch2'] = 0.112;
    $params['hubble'] = 70;
    $params['re_optical_depth'] = 0.09;
    $params['omk'] = 0;

    $params['output_root'] = 'test';
    return $params;
}

function build_template($param, $label, $values)
{
    $params = default_params();

    echo "Calculating CMB TT power spectrum for different values of $param...\n";
    foreach($values as $value)
    {
        $params[$param] = $value;
        $params['output_root'] = "output_{$param}_{$value}";
        ob_get_clean();
        ob_start();
        include "template.ini";
        $output = ob_get_clean();
        file_put_contents("params_{$param}_{$value}.ini", $output);

        exec("cd CAMB; ./camb \"../params_{$param}_{$value}.ini\"");
        file_put_contents('../../plots/data/' . $params['output_root'] . '.res', "#$label = $value\n" . file_get_contents('CAMB/' . $params['output_root'] . '_lenspotentialCls.dat') );
    }
}


build_template("scalar_amp(1)", '\Delta R^{2}', array(2.1e-10, 2.1e-9, 2.1e-8));

build_template("scalar_spectral_index(1)", 'n_{s}', array(0.9, 0.96, 1.0, 1.1));

build_template("ombh2", '\Omega_{b} h^2', array(0.003, 0.01, 0.0226, 0.03));

build_template("omch2", '\Omega_{cdm} h^2', array(0.05, 0.112, 0.15));

build_template("re_optical_depth", '\tau', array(0.01, 0.09, 0.18));

build_template("hubble", 'h', array(60, 70, 80));

build_template("omk", '\Omega_{k}', array(-0.2, 0, 0.2));
