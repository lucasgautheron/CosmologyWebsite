#include <stdio.h>
#include <math.h>
#include <omp.h>

const double mu = 2;

const double radmodifier = 0.001;

const double alpha = 0.00018181636;
const double beta = 499699.060742 * (radmodifier * radmodifier * radmodifier);
const double r = 0.00000424425 / radmodifier; // r scharw / r sun

const double dchi = 0.00005;
const int steps = 20000000;

#include "white_dwarf.h"


int main()
{
    double radius, mass, external_mass, x0 = 1000;
    
    //calculate_star(0.1, true, radius, mass, external_mass);
    //calculate_star(1, true, radius, mass, external_mass);
    //calculate_star(10, true, radius, mass, external_mass);
    calculate_star(100, dchi, true, radius, mass, external_mass, true);
    //calculate_star(10000, true, radius, mass, external_mass);
    return 0;
}
