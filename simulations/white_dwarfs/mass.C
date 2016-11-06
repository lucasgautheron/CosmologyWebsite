#include <stdio.h>
#include <math.h>
#include <omp.h>

const double mu = 2;

const double radmodifier = 0.001;

const double alpha = 0.00018181636;
const double beta = 499699.060742 * (radmodifier * radmodifier * radmodifier);
const double r = 0.00000424425 / radmodifier; // r scharw / r sun

const int steps = 50000000;

#include "white_dwarf.h"

int main()
{
    const int N = 100;
    
    double radius[N], mass[N], external_mass[N], x0[N];
    
    #pragma omp parallel for schedule(dynamic, 1)
    for(int i = 0; i < N; ++i)
    {
        x0[i] = pow(10, -1.5+8.5*double(i)/double(N));
        double dchi = x0[i] > 1e4 ? 0.00001 : 0.0001;
        if(x0[i] > 1e6) dchi /= 2;
        
        calculate_star(x0[i], dchi, false, radius[i], mass[i], external_mass[i]);
        printf("%d / %d done.\n", i+1, N);
    }
    
    FILE *fp = fopen("mass_radius.res", "w+");
    for(int i = 0; i < N; ++i)
    {
        fprintf(fp, "%f %f %f %f\n", x0[i], radius[i] * radmodifier, mass[i], external_mass[i]);
    }
    fclose(fp);
    
    #pragma omp parallel for schedule(dynamic, 1)
    for(int i = 0; i < N; ++i)
    {
        x0[i] = pow(10, -1.5+8.5*double(i)/double(N));
        double dchi = x0[i] > 1e4 ? 0.000001 : 0.0001;
        if(x0[i] > 1e6) dchi /= 2;
        
        calculate_star(x0[i], dchi, true, radius[i], mass[i], external_mass[i]);
        printf("%d / %d done.\n", i+1, N);
    }
    
    fp = fopen("mass_radius_relativistic.res", "w+");
    for(int i = 0; i < N; ++i)
    {
        fprintf(fp, "%f %f %f %f\n", x0[i], radius[i] * radmodifier, mass[i], external_mass[i]);
    }
    fclose(fp);
    return 0;
}
