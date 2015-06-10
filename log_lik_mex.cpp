#include <mex.h>

#include <cstdint>
#include <algorithm>

typedef std::int16_t lag_t;
const mxClassID lag_t_mx_class = mxINT16_CLASS;

double logsumexp(const double * x, size_t n)
{
    const auto x_max = *std::max_element(x, x + n);
    double y = 0.;
    
    for (size_t i = 0; i < n; ++i)
        y += exp(x[i] - x_max);
    
    return log(y) + x_max;
}

// size(y) = [K, N]
// size(tau) = [K, N_theta]
// size(logL) = [N_theta]
void log_lik(const double * y, size_t K, size_t N, const lag_t * tau, size_t N_theta, double sigma_n, double * logL)
{
    for (size_t i = 0; i < N_theta; ++i)
    {
        const lag_t * tau_i = tau + i * K;
        const auto tau_max = *std::max_element(tau_i, tau_i + K);
        const auto tau_min = *std::min_element(tau_i, tau_i + K);
        
        logL[i] = 0;

        for (int j = -tau_max; j < static_cast<int>(N) - tau_min; ++j)
        {
            double R_square = 0.;
            double M = 0.;
            size_t nS = 0;
            
            for (size_t k = 0; k < K; ++k)
            {
                // "Active channel set": {k : 0 <= j + tau(k) < N}
                if (0 <= j + tau_i[k] && j + tau_i[k] < N)
                {
                    const auto z = y[(j + tau_i[k]) * K + k];
                    M += z;
                    R_square += z * z;
                    ++nS;
                }
            }   
            
			if (nS > 0)
			{
				// L(i) = L(i) - log(nS) / 2 + (M_square / nS - R_square) / (2 * this.sigma_n^2);
				logL[i] += -log(nS) / 2. + (M * M / nS - R_square) / (2. * sigma_n * sigma_n);
			}
        }
    }
}

// log_lik_mex(y, tau, sigma_n)
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs != 3)
        mexErrMsgTxt("log_lik_mex() takes exactly 3 arguments");
    
    if (nlhs != 1)
        mexErrMsgTxt("log_lik_mex() returns exactly 1 argument");
    
    const mxArray * mx_y = prhs[0];
    const mxArray * mx_tau = prhs[1];
    const double sigma_n = mxGetScalar(prhs[2]);
    
    const double * py = mxGetPr(mx_y);
    const size_t K = mxGetM(mx_y);
    const size_t N = mxGetN(mx_y);
    
    if (mxGetM(mx_tau) != K)
        mexErrMsgTxt("log_lik_mex(): number of columns in y and tau must be equal");
    
    if (mxGetClassID(mx_tau) != lag_t_mx_class)
        mexErrMsgTxt("log_lik_mex(): tau has wrong data type");
    
    const auto * ptau = reinterpret_cast<const lag_t *>(mxGetData(mx_tau));
    const size_t N_theta = mxGetN(mx_tau);
        
    mxArray * mx_logL = mxCreateDoubleMatrix(N_theta, 1, mxREAL);
    double * plogL = mxGetPr(mx_logL);
    
    log_lik(py, K, N, ptau, N_theta, sigma_n, plogL);
    
    plhs[0] = mx_logL;
}