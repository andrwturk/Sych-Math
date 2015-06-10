classdef Si4 < handle
    % Si4
    
    properties
        r_rec;
        theta;
        sigma_n;
        v;
        fs;
        windowLength;
        windowOffset;
    end
    
    properties (Dependent)
        tau;
    end
    
    methods
        function this = Si4()
            L = 1;
            n_rec = 3;
            R = L / (2 * sin(pi / n_rec));
            v_ = 330;
            fs_ = 51000;
            
            phi = 2 * pi / n_rec * (0 : n_rec - 1).';                
            r_rec_ = R * [cos(phi), sin(phi)];
            
            theta_ = deg2rad(-180 : 179);
            
            this.r_rec = r_rec_;
            this.theta = theta_;
            this.sigma_n = 0.003;
            this.v = v_;
            this.fs = fs_;
            this.windowLength = ceil(2 * L / v_ * fs_);
            this.windowOffset = round(this.windowLength / 4);
        end
        
        function val = get.tau(this)
            val = round(signal_lag(this.r_rec, this.theta) / this.v * this.fs);
        end
    end    
end

