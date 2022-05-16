function [ff, P1] = frequencytrans(signal)
    Fs = 600; %sampling freqz
    L = length(signal); % length of signal
    % sampling freqz/2 and 512 points between that value
    
    Y = fft(signal); % fft of the signal
    
    %convert to single sided
    
    P2 = abs(Y/L); % abs of fft divided by the length of the signal
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    ff = Fs*(0:(L/2))/L; %taking the right side 0-480Hz
end