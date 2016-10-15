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

function build_template_params($value_sets, $labels)
{
    $params = default_params();
    $modified_params = array_keys($value_sets[0]);

    echo "Calculating CMB TT power spectrum for different values of (" . join(",", $modified_params) . ")...\n";

    foreach($value_sets as $value_set)
    {
        foreach($value_set as $param => $value) $params[$param] = $value;
        $params['output_root'] = "output_" . join("-", $modified_params) . "_" . join("_", $value_set);
        ob_get_clean();
        ob_start();
        include "template.ini";
        $output = ob_get_clean();
        file_put_contents("params_" . join("-", $modified_params) . "_" . join("_", $value_set).".ini", $output);

        exec("cd CAMB; ./camb \"../params_" . join("-", $modified_params) . "_" . join("_", $value_set).".ini\"");

        $label_values = array();
        foreach($modified_params as $param)
        {
            $label_values[] = $labels[$param] . " = " . $value_set[$param];
        }
        file_put_contents('../../plots/data/' . $params['output_root'] . '.res', "#" . join(",", $label_values) . "\n" . file_get_contents('CAMB/' . $params['output_root'] . '_lenspotentialCls.dat') );
    }
}


build_template("scalar_amp(1)", "{/Symbol d} R^{2}", array(2.1e-10, 2.1e-9, 2.1e-8));

build_template("scalar_spectral_index(1)", "n_{s}", array(0.9, 0.96, 1.0, 1.1));

build_template("ombh2", "{/Symbol O}_{b} h^2", array(0.003, 0.01, 0.0226, 0.03));

build_template("omch2", "{/Symbol O}_{cdm} h^2", array(0.05, 0.112, 0.15));

build_template("re_optical_depth", "{/Symbol t}", array(0.01, 0.09, 0.18));

build_template("hubble", "h", array(60, 70, 80));

build_template("omk", "{\Symbol O}_{k}", array(-0.2, 0, 0.2));

$coldmatter = 0.0226+0.112;
build_template_params(array(array("ombh2" => 0.003, "omch2" => $coldmatter - 0.003), array("ombh2" => 0.0226, "omch2" => $coldmatter - 0.0226), array("ombh2" => $coldmatter, "omch2" => 0)), array("ombh2" => "{/Symbol O}_{b} h^2", "omch2" => "{/Symbol O}_{cdm} h^2"));
