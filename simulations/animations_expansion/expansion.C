#include <math.h>
#include <stdio.h>


const double beta = 2.0/3.0;
double t0_acc = 1, t0_dec = 1;

double a_dec(double t)
{
    return pow(t/t0_dec, beta);
}

double a_acc(double t)
{
    return exp(t/t0_acc);
}

int calculate(const double d, const double t1, double (*a)(double), double *_x, double *_r, double *_z, double *_t, double *_dr, int n)
{
    double xA = -d/2.0;
    double xB = d/2.0;

    double dt = 0.001;
    double x = xA, t = t1;

    for(int i = 0; i < n; ++i)
    {
        _x[i] = _r[i] = _z[i] = _t[i] = 0;
    }
    
    _x[0] = xA;
    _r[0] = 0;
    _z[0] = 0;
    _t[0] = t;

    int i = 1;
    while(x < xB)
    {
        if(i >= n) { printf("n is too small :'( %f %d", x, i); return 1; }
        x += a(t1) * dt/a(t);
        t += dt;

        _x[i] = x;
        _dr[i] = ((x-xA) * a(t)/a(t1) - _r[i-1])/dt;
        _r[i] = (x-xA) * a(t)/a(t1);
        _t[i] = t;
        _z[i] = a(t)/a(t1) - 1;
        ++i;
    }    
    
}

int main()
{
    const int n = 100000;
    const double z = 5;
    
    t0_acc = 1;
    const double t1_acc = 0, d_acc = (z/(1+z)) * t0_acc;
    
    t0_dec = 2.0/3.0;
    // lookback time = 0.932 = int_0^5 dz/(1+z)^(5/2)
    const double t1_dec = t0_dec * (1-0.932), d_dec = (pow(z+1, (1-beta)/beta) - 1) * pow(t0_dec, beta) * pow(t1_dec, 1-beta) / (1-beta) * a_dec(t1_dec);
    
    
    printf("%.5f %.5f\n", t1_dec, d_dec);
    
    double *x_acc = new double[n], *r_acc = new double[n], *z_acc = new double[n], *t_acc = new double[n], *dr_acc = new double[n];
    double *x_dec = new double[n], *r_dec = new double[n], *z_dec = new double[n], *t_dec = new double[n], *dr_dec = new double[n];
    calculate(d_acc, t1_acc, &a_acc, x_acc, r_acc, z_acc, t_acc, dr_acc, n);
    calculate(d_dec, t1_dec, &a_dec, x_dec, r_dec, z_dec, t_dec, dr_dec, n);
    FILE *fp = fopen("out_acc.res", "w+");
    for(int i = 0; i < n; ++i)
    {
        if(i && t_acc[i] < t_acc[i-1]) break;
        fprintf(fp, "%f %f %f %f %f\n", t_acc[i], x_acc[i], r_acc[i], z_acc[i], dr_acc[i]);
    }
    fclose(fp);
    fp = fopen("out_dec.res", "w+");
    for(int i = 0; i < n; ++i)
    {
        if(i && t_dec[i] < t_dec[i-1]) break;
        fprintf(fp, "%f %f %f %f %f\n", t_dec[i], x_dec[i], r_dec[i], z_dec[i], dr_dec[i]);
    }
    fclose(fp);
    return 0;
}
