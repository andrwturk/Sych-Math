classdef FilterBeamformer < handle
    % Passes incoming signal through a correlation filter and then does
    % beamforming. Processes the data framewise.
    
    properties (SetAccess = private)
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
        
        % Frequency-domain signal to detect with the correlation filter (signature).
        S;
        
        % Length of the signature signal in samples. 
        sigLength;
        
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
        
        % Number of DoA (directions of arrival).
        numDirections;
    end
    
    methods
        function this = FilterBeamformer(sig, tau, frame_length)
            % Constructor.
            %
            % sig -- trequency-domain signal to detect with the correlation
            %   filter (signature). Must be a row vector.
            % tau [K x M] -- matrix of channel delays. Rows of tau correspond to channels,
            %   columns correspond to different directions of arrival (DoA). 
            %   I.e., tau(k, i) = delay for channel k and DoA i.
            % frame_length -- length of data processing frame in samples.
            
            % Init sensor array.
            assert(ismatrix(tau));
            tau = tau - max(tau(:));    % Make all tau's non-positive (-tau non-negative), so that the the first samples
                                        % do not come in the end of the (padded) buffer due to negative
                                        % circular shifts. This naturally introduces additional delay to output signal.
            
            % Init correlation filter
            assert(isrow(sig));
            
            % Length of fft buffer. Pad the buffer so that circular
            % convolution of signal frame with sig followed by the
            % beamforming time shift does not wrap around.
            Ns = length(sig);
            N = frame_length + Ns - 1 + ceil(max(-tau(:)));
            
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
            this.tau    = tau;
            this.S      = S;
            this.sigLength      = Ns;
            this.frameLength    = frame_length;
            this.bufferLength   = N;
            this.passBand       = passband;
            this.passBandFreqInd    = ind;
            this.passBandFreq       = f(ind);
            this.tail   = zeros(size(tau, 2), N - frame_length);
        end
        
        function y = ProcessFrame(this, x)
            % Process data frame.
            %
            % x -- [numChannels x frameLength] matrix of input signal
            %   samples in time domain.
            % returns
            % y -- [numDirections x frameLength] filtered-beamformed
            %   signal. y(i, t) is filtered signal intensity from direction
            %   i at time t.
            
            % ** Get sizes **
            assert(ismatrix(x) && size(x, 1) == this.numChannels);
            Nt = size(x, 2);
            assert(Nt == this.frameLength);
            Nk = size(this.tau, 2);
    
            % Pad x with zeros from left and right.
            x_ = zeros(this.numChannels, this.bufferLength);
            x_(:, this.sigLength + (0 : Nt - 1)) = x;

            % ** Convert x to frequency domain **
            X = fft(x_, [], 2);
            
            % ** Compute correlation **
            X = X .* repmat(conj(this.S), this.numChannels, 1);
   
            % ** Beamforming **
            assert(all(-this.tau(:) >= 0));
            Y = zeros(Nk, this.bufferLength);
            Y(:, this.passBandFreqInd) = beamforming(X(:, this.passBandFreqInd), this.passBandFreq, -this.tau);

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
        
        function val = get.numDirections(this)
            val = size(this.tau, 2);
        end
    end
    
end

