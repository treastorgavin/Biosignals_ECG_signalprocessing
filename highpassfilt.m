function filtdat = highpassfilt (data)

[b,a] = butter(5, 0.01, 'high');

filtdat = filtfilt(b,a,data);

end