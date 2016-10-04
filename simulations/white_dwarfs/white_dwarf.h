#define PI 3.141592654

#define max(a,b) ((a)>(b)? (a) : (b))

inline double pressure(double x)
{
    double root = pow(x, 1.0/3.0);
    return (3.0/8.0) * log(root + sqrt(root*root+1)) + sqrt(1+root*root) * (0.25 * x - (3.0/8.0) * root); 
    
}

inline double energy(double x)
{
    double root = pow(x, 1.0/3.0);
    return (1.0/8.0) * ( log(root + sqrt(root*root+1)) + sqrt(1+root*root) * (2 * x - root) ); 
}

inline double dpressure(double x)
{
    return pow(x, 2.0/3.0)/(3.0*sqrt( 1 + pow(x, 2.0/3.0) ));
}

inline double find_x_from_pressure(double p, double x0 = 1)
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

bool calculate_star(const double x0, const double _dchi, const bool relativistic, double &radius, double &mass, double &external_mass, bool save_profile = false)
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
    
    
    char filename[64] = "";
    FILE *fp = NULL;
    if(save_profile)
    {
        sprintf(filename, "mass_%.5f.res", x0);
        fp = fopen(filename, "w+");
    }
    
    bool converged = false;
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
        
        if(save_profile) fprintf(fp, "%f %f %f %f %f %f\n", chi[1] * radmodifier, m[1], M[1], p[1], x[1]/3.0, x[1]/3.0 + e_correction);
        m[0] = m[1];
        M[0] = M[1];
        p[0] = p[1];
        e[0] = e[1];
        x[0] = x[1];
    }
    
    if(!converged) printf("DID NOT CONVERGE : ADD MORE STEPS");
    else printf("%d steps\n", i);
    
    if(save_profile) fclose(fp);
}
