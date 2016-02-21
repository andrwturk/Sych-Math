classdef FilterBeamformer < handle
    % Passes incoming signal through a correlation filter and then does
    % beamforming. Processes the data framewise.
    
    properties (SetAccess = private)
        % In/out signal sampling frequency, [Hz].
        fs;
        
        % passBand [1 x 2] -- frequency passband (in normalized frequency units).
        %   Only the frequencies within the passband are processed.
        passBand;
        
        % Indices of spectrum samples which are within the passBand.
        passBandFreqInd;
        
        % Normalized frequencies corresponding to passBandFreqInd.
        passBandFreq;
        
        % Tau [K x M] -- array of channel delays. Rows of tau correspond to channels,
        % columns correspond to different directions of arrival (DoA). 
        % I.e., tau(k, i) = delay for channel k and DoA [Theta(i), Phi(i)].
        tau;
        
        % Asimuth of direction of arrival.
        theta;
        
        % Elevation alngle of direction of arrival.
        phi;
        
        % Frequency-domain signal to detect with the correlation filter.
        S;
        
        % Maximum length of the processing frame in samples.
        frameLength;
        
        % Full length of the FFT buffer in samples.
        bufferLength;
        
        % Tail from the previous frame.
        tail;
    end
    
    properties (Dependent = true)
        % Number of channels (microphones).
        numChannels;
    end
    
    methods
        function this = FilterBeamformer(frame_length)
            % Init sensor array.
            v = sound_speed_air(293);
            r = sensor_position() / v;
            
            % Init angles and lags.
            phi = linspace(0, 2 * pi, 361);
            theta = 0;
            [Phi, Theta] = meshgrid(phi, theta);
            
            fs = 51000;
            tau = -r.' * direction(Phi(:).', Theta(:).') * fs;
            tau = tau - max(tau(:));    % Make all tau's non-positive (-tau non-negative), so that the the first samples
                                        % do not come in the end of the (padded) buffer due to negative
                                        % circular shifts. This naturally introduces additional delay to output signal.
            
            % Init correlation filter
            S_data = load('data/sig.mat', 'sig');    % Load AK-47 muzzleflash signature signal
            sig = S_data.sig;
            assert(isrow(sig));
            
            % Length of fft buffer. Pad the buffer so that circular
            % convolution of signal frame with sig followed by the
            % beamforming time shift does not wrap around.
            N = frame_length + Ns - 1 + ceil(max(tau(:)));
            
            % Make N odd, for correct frequency-domain shift.
            if mod(N, 2) == 0
                N = N + 1;
            end

            % Pad sig with zeros.
            sig(:, end + 1 : N) = 0;

            % ** Convert signature signal to frequency domain **
            S = fft(sig, [], 2);
            
            % Normalized frequency vector
            f = fft_freq_vector(N);

            % Indices corresponding to the frequency passband.
            passband = [0, Inf];
            ind = passband(1) <= abs(f) & abs(f) <= passband(2);

            % Init properties.            
            this.fs     = fs;
            this.tau    = tau;
            this.phi    = Phi;
            this.theta  = Theta;
            this.S      = S;
            this.frameLength    = frame_length;
            this.bufferLength   = N;
            this.passBand       = passband;
            this.passBandFreqInd    = ind;
            this.passBandFreq       = f(ind);
        end
        
        function y = ProcessFrame(this, x)
            % ** Get sizes **
            assert(ismatrix(x) && size(x, 1) == this.numChannels);
            Nt = size(x, 2);
            assert(Nt == this.frameLength);
            Nk = size(this.tau, 2);
    
            % Pad x with zeros.
            x(:, end + 1 : this.bufferLength) = 0;

            % ** Convert x to frequency domain **
            X = fft(x, [], 2);

            % ** Compute correlation **
            X = X .* repmat(conj(this.S), Nc, 1);

            % ** Beamforming **
            Y = zeros(Nk, N);
            Y(:, this.passBandFreqInd) = beamforming(X(:, this.passBandFreqInd), f(this.passBandFreqInd), -this.tau);

            % ** Convert to time domain **
            y = ifft(Y, [], 2);
            
            % Add tail from the previous frame.
            tail_length = this.bufferLength - this.frameLength;
            y(:, 1 : tail_length) = y(:, 1 : tail_length) + this.tail;
            
            % Make a new tail.
            this.tail = y(:, end - tail_length + 1 : end);
            
            % Return only first Nt samples of y, the rest goes in the tail
            % and will be returned on next calls.
            y = y(:, 1 : Nt);
        end
        
        function val = get.numChannels(this)
            val = size(this.tau, 1);
        end
    end
    
end

