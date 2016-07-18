#include <stdio.h>
#include <math.h>
#include <omp.h>

#define PI 3.141592654

#define max(a,b) ((a)>(b)? (a) : (b))

double pressure(double x)
{
    double root = pow(x, 1.0/3.0);
    return (3.0/8.0) * log(root + sqrt(root*root+1)) + sqrt(1+root*root) * (0.25 * x - (3.0/8.0) * root); 
    
}

double energy(double x)
{
    double root = pow(x, 1.0/3.0);
    return (1.0/8.0) * ( log(root + sqrt(root*root+1)) + sqrt(1+root*root) * (2 * x - root) ); 
}

double dpressure(double x)
{
    return pow(x, 2.0/3.0)/(3.0*sqrt( 1 + pow(x, 2.0/3.0) ));
}

double find_x_from_pressure(double p, double x0 = 1)
{
    const double max_error = 1e-10;
    const int max_iterations = 1000;
    
    double x = x0, x1 = x0, error = max_error+1;
    
    int i = 0;
    while (error > max_error && i < max_iterations)
    {
        x1 = x - (pressure(x)-p)/(dpressure(x));
        error = fabs(x1-x);
        x = x1;
        ++i;
    }
    return x;
}

const double mu = 2;

const double radmodifier = 0.001;

const double alpha = 0.00018181636;
const double beta = 499699.060742 * (radmodifier * radmodifier * radmodifier);
const double r = 0.00000424425 / radmodifier; // r scharw / r sun

const double dchi = 0.0000001;
const int steps = 5000000;

bool calculate_star(const double x0, const bool relativistic, double &radius, double &mass, double &external_mass)
{
    double x[2], m[2], M[2], p[2], e[2], chi[2];
    
    // initialisation
    for(int i = 0; i < 2; ++i)
    {
        x[i] = m[i] = M[i] = p[i] = e[i] = chi[i] = 0;
    }
    
    // conditions aux limites
    m[0] = M[0] = 0;
    x[0] = x0;
    p[0] = pressure(x[0]);
    
    //FILE *fp = fopen("masse.res", "w+");
    
    bool converged = false;
    double _dchi = x0 > 1e4 ? 0.000001 : 0.0001;
    if(x0 > 1e6) _dchi /= 2.0;
    //double _dchi = x0 > 1e4 ? 0.000001 : 0.0001;
    int i = 1;
    for(; i < steps; ++i)
    {
        
        chi[1] = double(i) * _dchi;
        //chi[1] += _dchi;
        double dm = _dchi * (4.0/3.0) * PI * mu * beta * chi[1] * chi[1] * x[0];
        double e_correction = + 3 * alpha * e[0];
        M[1] = M[0] + dm / sqrt(1-M[0]*chi[1]*r);
        if(relativistic) dm += _dchi * (4.0/3.0) * PI * beta * chi[1] * chi[1] * e_correction;
        m[1] = m[0] + dm;
        
        if(relativistic)
        {
            p[1] = p[0] - _dchi * (r/(2*alpha*chi[1]*chi[1])) * (mu * x[0]/3.0 + alpha * p[0] + e_correction ) * (m[0] + 4*PI*alpha * beta * chi[1]*chi[1]*chi[1]*p[0]) / (1-r*m[0]/chi[1]);
        }
        else
        {
            p[1] = p[0] - _dchi * (r/(2*alpha*chi[1]*chi[1])) * mu * x[0]/3.0 * m[0];
        }
        x[1] = find_x_from_pressure(p[1], x[0]);
        e[1] = energy(x[0]);
        
        if(p[1] < 0) 
        {
            mass = M[0];
            radius = chi[1];
            external_mass = m[0];
            converged = true;
            break;
        }
        
        //fprintf(fp, "%f %f %f %f\n", chi[1], m[1], p[1], x[1]);
        m[0] = m[1];
        M[0] = M[1];
        p[0] = p[1];
        e[0] = e[1];
        x[0] = x[1];
    }
    
    if(!converged) printf("DID NOT CONVERGE : ADD MORE STEPS");
    else printf("%d steps\n", i);
    
    //fclose(fp);
}


int main()
{
    const int N = 200;
    
    double radius[N], mass[N], external_mass[N], x0[N];
    
    #pragma omp parallel for
    for(int i = 0; i < N; ++i)
    {
        x0[i] = pow(10, -1.5+8.5*double(i)/double(N));
        
        calculate_star(x0[i], false, radius[i], mass[i], external_mass[i]);
        printf("%d / %d done.\n", i+1, N);
    }
    
    FILE *fp = fopen("masse_rayon.res", "w+");
    for(int i = 0; i < N; ++i)
    {
        fprintf(fp, "%f %f %f %f\n", x0[i], radius[i] * radmodifier, mass[i], external_mass[i]);
    }
    fclose(fp);
    
    #pragma omp parallel for
    for(int i = 0; i < N; ++i)
    {
        x0[i] = pow(10, -1.5+8.5*double(i)/double(N));
        
        calculate_star(x0[i], true, radius[i], mass[i], external_mass[i]);
        printf("%d / %d done.\n", i+1, N);
    }
    
    fp = fopen("masse_rayon_relativistic.res", "w+");
    for(int i = 0; i < N; ++i)
    {
        fprintf(fp, "%f %f %f %f\n", x0[i], radius[i] * radmodifier, mass[i], external_mass[i]);
    }
    fclose(fp);
    return 0;
}
