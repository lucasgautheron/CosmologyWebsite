#include <stdio.h>
#include <string.h>
#include <math.h>

int Integrate(const double o_m0, const double o_v0, const double z, const int N, double *I)
{
    double dz = z/double(N);
    I[0] = 0;
   
    for(int i = 0; i < N-1; ++i)
    {
        const double lz = z * double(i) / double(N);
        I[i+1] = I[i] + dz / sqrt(o_m0*(1+lz)*(1+lz)*(1+lz) + o_v0);
    }
    return 0;
}

int PrintResults(const char *name, double o_m0, double o_v0)
{
    const int N = 10000;
    const double Z = 10.0;
    double I[N];
    
    Integrate(o_m0, o_v0, Z, N, I);

    char fname[64] = "";
    sprintf(fname, "%s.res", name);

    FILE *fp = fopen(fname, "w+");

    for(int i = 0; i < N; ++i)
    {
        const double z = Z * double(i)/double(N);
        fprintf(fp, "%f %f\n", z, (1+z) * I[i]);
    }

    fclose(fp);

    return N;
}

int main()
{
    PrintResults("einstein_desitter", 1, 0);
    PrintResults("planck", 0.31, 0.69);
    PrintResults("hoyle", 0, 1);
    return 0;
}
