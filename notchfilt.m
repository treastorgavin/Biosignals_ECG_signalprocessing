function [filt_dat] = notchfilt(data)

    %from pre lab
    b = [0.995,-1.6099,0.995];
    a = [1,-1.6019,0.9801];
    
    %applying filter
    filt_dat = filtfilt(b,a,data);
end