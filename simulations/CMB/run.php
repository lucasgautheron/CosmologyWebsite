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

    $params['output_root'] = 'test';
    return $params;
}

function build_template($param, $label, $values)
{
    $params = default_params();

    foreach($values as $value)
    {
        $params[$param] = $value;
        $params['output_root'] = "output_{$param}_{$value}";
        ob_get_clean();
        ob_start();
        include "template.ini";
        $output = ob_get_clean();
        file_put_contents("params_{$param}_{$value}.ini", $output);

        exec("cd CAMB; ./camb \"../params_{$param}_{$value}.ini\" &");
        file_put_contents('../../plots/data/' . $params['output_root'] . '.res', "#$label = $value\n" . file_get_contents('CAMB/' . $params['output_root'] . '_lenspotentialCls.dat') );
    }
}


build_template("scalar_amp(1)", "{/Symbol d} R^{2}", array(2.1e-10, 2.1e-9, 2.1e-8));

build_template("scalar_spectral_index(1)", "n_{s}", array(0.9, 0.96, 1.0, 1.1));

build_template("ombh2", "{/Symbol O}_{b} h^2", array(0.01, 0.0226, 0.03));

build_template("omch2", "{/Symbol O}_{cdm} h^2", array(0.05, 0.112, 0.15));

build_template("re_optical_depth", "{/Symbol t}", array(0.01, 0.09, 0.18));

build_template("hubble", "H_{0}", array(60, 70, 80));
