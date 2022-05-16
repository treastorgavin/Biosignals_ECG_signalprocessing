%% Loading in the data
clc

fs = 600;

sitECG = csvread("sitECG.csv",1,1);
sitECG = sitECG(:,1);

layingECG = csvread("layingECG.csv",1,1);
layingECG = layingECG(:,1);

time = (1:length(sitECG))/fs;

% figure(1)
% points = 2;
% plot(time,sitECG);
% [X,~]=ginput(points);
% X = floor(X*fs);
% sitECG4beats = sitECG(X(1):X(2)); % the data between the 2 points
% clear screen
%%
s1 = 1844;
s2 = 3600;

sitECG = sitECG(s1:s2);

beatTime = (s1:s2)/fs;

subplot(2,1,1)
plot(beatTime,sitECG);
title("First 4 beats of sitting ECG");
xlabel("time (s)")
ylabel("Amplitude (mV)")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

% time = (1:length(layingECG))/fs;
% figure(1)
% points = 2;
% plot(time,layingECG);
% [X,~]=ginput(points);
% X = floor(X*fs);
% layECG4beats = layingECG(X(1):X(2)); % the data between the 2 points
% clear screen

% took the first 4 beats that looked normal
l1 = 9248;
l2 = 11732;


beatTimeL = (l1:l2)/fs;

layECG = layingECG(l1:l2);

% zeroing the layECG4beats
layECG = layECG - mean(layECG);

subplot(2,1,2)
plot(beatTimeL,layECG);
title("First 4 beats of laying ECG");
xlabel("time (s)")
ylabel("Amplitude (mV)")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);


% Calculating the HR
% average time between R complex's (done on paper)

% in bpm
sitHR = (1/0.726)*60;
layHR = (1/1.033)*60;

%% E1 Q3 Find lead II using leads I and III
% Calculating lead II from I and III
% QRS potentials are measured along Lead I and III, added together, and 
% then the mean electrical axis can be computed by finding the magnitude 
% and direction of the vector representing Lead II.

sitECG3 = csvread("sitECG.csv",1,1);
sitECG3 = sitECG3(:,3);

layECG3 = csvread("layingECG.csv",1,1);
layECG3 = layECG3(:,3);

sitECG3 = sitECG3(s1:s2);
layECG3 = layECG3(l1:l2);

% sum of both leads

calcSitECG2 = sitECG + sitECG3;
calcLayECG2 = layECG + layECG3;

% ECG lead 2

sitECG2 = csvread("sitECG.csv",1,1);
sitECG2 = sitECG2(:,2);
sitECG2 = sitECG2(s1:s2);

layECG2 = csvread("layingECG.csv",1,1);
layECG2 = layECG2(:,2);
layECG2 = layECG2(l1:l2);

figure(1)
subplot(2,1,1)
plot(beatTime,calcSitECG2);
hold on
plot(beatTime,sitECG2);
hold off
title("Sitting Lead II calculated vs real");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Calculated","Real");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

subplot(2,1,2)
plot(beatTimeL,calcLayECG2);
hold on
plot(beatTimeL,layECG2);
hold off
title("Laying Lead II calculated vs real");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Calculated","Real");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

sitERROR = calcSitECG2 - sitECG2;
layERROR = calcLayECG2 - layECG2;

figure (2)
subplot(2,1,1)
plot(beatTime, sitERROR);
title("Sit Lead II Error");
xlabel("time (s)")
ylabel("Amplitude (mV)")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

subplot(2,1,2)
plot(beatTimeL, layERROR);
title("Laying Lead II Error");
xlabel("time (s)")
ylabel("Amplitude (mV)")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

sitMS = (mean(sitERROR))^2; % mean squared of the section

layMS = (mean(layERROR))^2;

%% ====================== Artifact right and left =========================

fs = 600;

artifactL = csvread("artifactleftECG.csv",1,1);
artifactL1 = artifactL(:,1);
artifactL2 = artifactL(:,2);
artifactL3 = artifactL(:,3);

artifactR = csvread("artifactrightECG.csv",1,1);
artifactR1 = artifactR(:,1);
artifactR2 = artifactR(:,2);
artifactR3 = artifactR(:,3);

artL2s = 2*fs;
artL16s = 16*fs;
artR5s = 5*fs;
artR20s = 20*fs;

artifactL1 = artifactL1(artL2s:artL16s)-mean(artifactL1(artL2s:artL16s));
artifactL2 = artifactL2(artL2s:artL16s)-mean(artifactL2(artL2s:artL16s));
artifactL3 = artifactL3(artL2s:artL16s)-mean(artifactL3(artL2s:artL16s));

artifactR1 = artifactR1(artR5s:artR20s)-mean(artifactR1(artR5s:artR20s));
artifactR2 = artifactR2(artR5s:artR20s)-mean(artifactR2(artR5s:artR20s));
artifactR3 = artifactR3(artR5s:artR20s)-mean(artifactR3(artR5s:artR20s));

timeL = (artL2s:artL16s)/fs;
timeR = (artR5s:artR20s)/fs;

figure(1)
[ff, P1] = frequencytrans(artifactL1);
plot(ff, P1);
hold on
[ff, P1] = frequencytrans(artifactL2);
plot(ff,P1)
hold on
[ff, P1] = frequencytrans(artifactL3);
plot(ff,P1)
hold off
xlim([0 70]);
title('Single-Sided Amplitude Spectrum of artifact left')
legend("Lead I","Lead II","Lead III");
xlabel('Frequency (Hz)')
ylabel('|FFT|')
set(gca,'FontName','Times New Roman','FontSize',20);

figure(2)
[ff, P1] = frequencytrans(artifactR1);
plot(ff, P1);
hold on
[ff, P1] = frequencytrans(artifactR2);
plot(ff,P1)
hold on
[ff, P1] = frequencytrans(artifactR3);
plot(ff,P1)
hold off
xlim([0 70]);
title('Single-Sided Amplitude Spectrum of artifact right')
legend("Lead I","Lead II","Lead III");
xlabel('frequency (Hz)')
ylabel('|FFT|')
set(gca,'FontName','Times New Roman','FontSize',18);
%%
% Lead I = LA - RA
% Lead II = LL - RA
% Lead III = LL - LA

% rearrange to remove unwanted noise from leads
% LeadIIInoise = fft(artifactR2) - fft(artifactR1);

% Left arm
% artifactL2 is clean

ERROR = (artifactL1-artifactL3)/2;

LeadIclean = artifactL1-ERROR;
LeadIIIclean = artifactL3-ERROR;

figure(1)
subplot(2,1,1)
plot(timeL,artifactL1);
hold on
plot(timeL,LeadIclean);
hold off
legend("noisy","clean")
title("Left arm Lead I noisy vs clean signal");
xlabel("time (s)");
ylabel("Amplitude (mV)")
set(gca,'FontName','Times New Roman','FontSize',20);

% right arm

ERROR = (artifactR1+artifactR2)/2;

LeadIclean = artifactR1 - ERROR;
LeadIIclean = artifactR2 - ERROR;

subplot(2,1,2)
plot(timeR,artifactR1);
hold on
plot(timeR,LeadIclean);
hold off
legend("noisy","clean")
title("Right arm Lead I noisy vs clean signal");
xlabel("time (s)");
ylabel("Amplitude (mV)")
set(gca,'FontName','Times New Roman','FontSize',20);

%% ======================== E2 Filtering the ECG ==========================

% Butterworth filter

[b,a] = butter(10, 20/(fs/2), 'low');

% Hanning window, (window size of ~30)
bhann = hann(30);
bhann = bhann/sum(bhann);
ahann = zeros(1,length(bhann));
ahann(1,1) = 1;
% freqz(b, a)
% title("Butterworth filter");
%set(gca,'FontName','Times New Roman','FontSize',20);
freqz(bhann,ahann);
title("Hanning filter");
set(gca,'FontName','Times New Roman','FontSize',20);
%% applying the filters

% sitting
sitECGBUTT = filtfilt(b,a,sitECG);
sitECGHANN = filtfilt(bhann,ahann,sitECG);

sitECGBUTT2 = filtfilt(b,a,sitECG2);
sitECGHANN2 = filtfilt(bhann,ahann,sitECG2);

sitECGBUTT3 = filtfilt(b,a,sitECG3);
sitECGHANN3 = filtfilt(bhann,ahann,sitECG3);

figure (1)
% signal before and after filtering
subplot(3,1,1)
plot(beatTime, sitECG)
hold on
plot(beatTime, sitECGBUTT)
hold on
plot(beatTime, sitECGHANN)
hold off
title("Sitting Lead I filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

subplot(3,1,2)
plot(beatTime, sitECG2)
hold on
plot(beatTime, sitECGBUTT2)
hold on
plot(beatTime, sitECGHANN2)
hold off
title("Sitting Lead II filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

subplot(3,1,3)
plot(beatTime, sitECG3)
hold on
plot(beatTime, sitECGBUTT3)
hold on
plot(beatTime, sitECGHANN3)
hold off
title("Sitting Lead III filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

% ============================ laying =====================================
layECGBUTT = filtfilt(b,a,layECG);
layECGHANN = filtfilt(bhann,ahann,layECG);

layECGBUTT2 = filtfilt(b,a,layECG2);
layECGHANN2 = filtfilt(bhann,ahann,layECG2);

layECGBUTT3 = filtfilt(b,a,layECG3);
layECGHANN3 = filtfilt(bhann,ahann,layECG3);

figure (2)
% signal before and after filtering
subplot(3,1,1)
plot(beatTimeL, layECG)
hold on
plot(beatTimeL, layECGBUTT)
hold on
plot(beatTimeL, layECGHANN)
hold off
title("Laying Lead I filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

subplot(3,1,2)
plot(beatTimeL, layECG2)
hold on
plot(beatTimeL, layECGBUTT2)
hold on
plot(beatTimeL, layECGHANN2)
hold off
title("Laying Lead II filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

subplot(3,1,3)
plot(beatTimeL, layECG3)
hold on
plot(beatTimeL, layECGBUTT3)
hold on
plot(beatTimeL, layECGHANN3)
hold off
title("Laying Lead III filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

%% difference between the original and filtered signal

sitECGdiff = [(sitECG-sitECGBUTT) (sitECG-sitECGHANN)...
    (sitECG2-sitECGBUTT2) (sitECG2-sitECGHANN2)...
    (sitECG3-sitECGBUTT3) (sitECG3-sitECGHANN3)];

layECGdiff = [(layECG-layECGBUTT) (layECG-layECGHANN)...
    (layECG2-layECGBUTT2) (layECG2-layECGHANN2)...
    (layECG3-layECGBUTT3) (layECG3-layECGHANN3)];

% Signal Noise Ratio (SNR)
sitSNR = [snr(sitECGBUTT,sitECG) snr(sitECGHANN,sitECG)...
    snr(sitECGBUTT2,sitECG2) snr(sitECGHANN2,sitECG2)...
    snr(sitECGBUTT3,sitECG3) snr(sitECGHANN3,sitECG3)];

laySNR = [snr(layECGBUTT,layECG) snr(layECGHANN,layECG)...
    snr(layECGBUTT2,layECG2) snr(layECGHANN2,layECG2)...
    snr(layECGBUTT3,layECG3) snr(layECGHANN3,layECG3)];

figure (1)
% signal difference before and after filtering
subplot(3,1,1)
plot(beatTime, sitECGdiff(:,1))
hold on
plot(beatTime, sitECGdiff(:,2))
hold off
title("Sitting Lead I filtered vs unfiltered difference");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

subplot(3,1,2)
plot(beatTime, sitECGdiff(:,3))
hold on
plot(beatTime, sitECGdiff(:,4))
hold off
title("Sitting Lead II filtered vs unfiltered difference");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

subplot(3,1,3)
plot(beatTime, sitECGdiff(:,5))
hold on
plot(beatTime, sitECGdiff(:,6))
hold off
title("Sitting Lead III filtered vs unfiltered difference");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([3.1 6]);

figure (2)
% signal difference before and after filtering
subplot(3,1,1)
plot(beatTimeL, layECGdiff(:,1))
hold on
plot(beatTimeL, layECGdiff(:,2))
hold off
title("Laying Lead I filtered vs unfiltered difference");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

subplot(3,1,2)
plot(beatTimeL, layECGdiff(:,3))
hold on
plot(beatTimeL, layECGdiff(:,4))
hold off
title("Laying Lead II filtered vs unfiltered difference");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

subplot(3,1,3)
plot(beatTimeL, layECGdiff(:,5))
hold on
plot(beatTimeL, layECGdiff(:,6))
hold off
title("Laying Lead III filtered vs unfiltered difference");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Butterworth","Hanning");
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

%% ============================== NOTCH FILTERING =========================

layECGNOTCH1 = notchfilt(layECG);
layECGNOTCH2 = notchfilt(layECG2);
layECGNOTCH3 = notchfilt(layECG3);

subplot(3,1,1)
plot(beatTimeL, layECG)
hold on
plot(beatTimeL, layECGNOTCH1)
hold off
title("Laying Lead I filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Filtered")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

subplot(3,1,2)
plot(beatTimeL, layECG2)
hold on
plot(beatTimeL, layECGNOTCH2)
hold off
title("Laying Lead II filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Filtered")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

subplot(3,1,3)
plot(beatTimeL, layECG3)
hold on
plot(beatTimeL, layECGNOTCH3)
hold off
title("Laying Lead III filtered vs unfiltered");
xlabel("time (s)")
ylabel("Amplitude (mV)")
legend("Unfiltered","Filtered")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([15.43 19.5]);

%% Analysis of filter
%from pre lab
b = [0.995,-1.6099,0.995];
a = [1,-1.6019,0.9801];
freqz(b, a)
set(gca,'FontName','Times New Roman','FontSize',18);

%% Frequency domain analysis

figure(1)
[ff, P1] = frequencytrans(layECG);
plot(ff, P1);
hold on
[ff, P1] = frequencytrans(layECGNOTCH1);
plot(ff,P1)
hold off
xlim([0 70]);
title('Single-Sided Amplitude Spectrum of layingECG vs Notch Lead I')
xlabel('frequency (Hz)')
ylabel('|FFT|')
set(gca,'FontName','Times New Roman','FontSize',18);

%% ======== Ex3: Time-Frequency Analysis of Cardiac Abnormalities =========

Fs = 360;

sinus = load("Normal Sinus Rhythm 1.txt");
SV_tachyarrythmia = load("Supraventricular Tachyarrhythmia 1.txt");
V_flutter = load("Ventricular Flutter 3.txt");
V_trigeminy = load("Ventricular Trigeminy 1.txt");


sin1 = 8101;
sin2 = 9892;

time = (sin1:sin2)/Fs;
% zeroing the signals
sinus = sinus(sin1:sin2)-mean(sinus(sin1:sin2));
SV_tachyarrythmia = SV_tachyarrythmia(sin1:sin2)-mean(SV_tachyarrythmia(sin1:sin2));
V_flutter = V_flutter(1809:3748)-mean(V_flutter(1809:3748));
V_trigeminy = V_trigeminy(sin1:sin2)-mean(V_trigeminy(sin1:sin2));

subplot(2,2,1)
plot(time,sinus);
title("Normal Sinus Rhythm 1");
xlabel("time (s)")
ylabel("Amplitude (µV)")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([22.5 27.4])

subplot(2,2,2)
plot(time,V_trigeminy);
title("Ventricular Trigeminy 1");
xlabel("time (s)")
ylabel("Amplitude (µV)")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([22.5 27.4])

subplot(2,2,3)
timeV = (1809:3748)/Fs;
plot(timeV,V_flutter);
title("Ventricular Flutter 3");
xlabel("time (s)")
ylabel("Amplitude (mV)")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([5 10.4])

subplot(2,2,4)
plot(time,SV_tachyarrythmia);
title("Supraventricular Tachyarrythmia 1");
xlabel("time (s)")
ylabel("Amplitude (µV)")
set(gca,'FontName','Times New Roman','FontSize',18);
xlim([22.5 27.4])


%% ======================= Removing baseline drift ========================

[b,a] = butter(10, 0.01, 'high');

Fs = 360;

sinus = load("Normal Sinus Rhythm 1.txt");
SV_tachyarrythmia = load("Supraventricular Tachyarrhythmia 1.txt");
V_flutter = load("Ventricular Flutter 3.txt");
V_trigeminy = load("Ventricular Trigeminy 1.txt");

int1 = 10*Fs;
int2 = 20*Fs;
time = (int1:int2)/Fs;

sinus = sinus(int1:int2)-mean(sinus(int1:int2));
SV_tachyarrythmia = SV_tachyarrythmia(int1:int2)-mean(SV_tachyarrythmia(int1:int2));
V_flutter = V_flutter(int1:int2)-mean(V_flutter(int1:int2));
V_trigeminy = V_trigeminy(int1:int2)-mean(V_trigeminy(int1:int2));

sinusfilt = highpassfilt(sinus);
SV_tachyarrythmiafilt = highpassfilt(SV_tachyarrythmia);
V_flutterfilt = highpassfilt(V_flutter);
V_trigeminyfilt = highpassfilt(V_trigeminy);


subplot(2,2,1)
plot(time,sinus);
hold on
plot(time,sinusfilt);
hold off
title("Normal Sinus Rhythm 1");
legend("Unfiltered","Filtered")
xlabel("time (s)")
ylabel("Amplitude (µV)")
set(gca,'FontName','Times New Roman','FontSize',18);

subplot(2,2,2)
plot(time,V_trigeminy);
hold on
plot(time,V_trigeminyfilt);
hold off
title("Ventricular Trigeminy 1");
xlabel("time (s)")
ylabel("Amplitude (µV)")
legend("Unfiltered","Filtered")
set(gca,'FontName','Times New Roman','FontSize',18);

subplot(2,2,3)
plot(time,V_flutter);
hold on
plot(time,V_flutterfilt);
hold off
title("Ventricular Flutter 3");
xlabel("time (s)")
legend("Unfiltered","Filtered")
ylabel("Amplitude (mV)")
set(gca,'FontName','Times New Roman','FontSize',18);

subplot(2,2,4)
plot(time,SV_tachyarrythmia);
hold on
plot(time,SV_tachyarrythmiafilt);
hold off
title("Supraventricular Tachyarrythmia 1");
xlabel("time (s)")
ylabel("Amplitude (µV)")
legend("Unfiltered","Filtered")
set(gca,'FontName','Times New Roman','FontSize',18);
%% Spectrograms

% sinus rhythm
figure (1)
subplot(3,1,1)
spectrogram(sinusfilt, 60, 0, 60, 360,'yaxis')
title("Spectrogram of Sinus window size 60");
set(gca,'FontName','Times New Roman','FontSize',18);
%ylim([0 30])

subplot(3,1,2)
spectrogram(sinusfilt, 360, 0, 360, 360, 'yaxis')
title("Spectrogram of Sinus with window 360");
set(gca,'FontName','Times New Roman','FontSize',18);

subplot(3,1,3)
spectrogram(sinusfilt, 720, 0, 720, 360, 'yaxis')
title("Spectrogram of Sinus with window 720");
set(gca,'FontName','Times New Roman','FontSize',18);

% Ventricular Trigeminy 1
figure (2)
subplot(3,1,1)
spectrogram(V_trigeminyfilt, 60, 0,60,360, 'yaxis')
title("Spectrogram of Ventricular Trigeminy 1 window size 60");
set(gca,'FontName','Times New Roman','FontSize',18);
%ylim([0 30])

subplot(3,1,2)
spectrogram(V_trigeminyfilt, 360,0,360,360, 'yaxis')
title("Spectrogram of Ventricular Trigeminy 1 with window 360");
set(gca,'FontName','Times New Roman','FontSize',18);

subplot(3,1,3)
spectrogram(V_trigeminyfilt, 720,0,720,360, 'yaxis')
title("Spectrogram of Ventricular Trigeminy 1 with window 720");
set(gca,'FontName','Times New Roman','FontSize',18);

% Ventricular Flutter 3
figure (3)
subplot(3,1,1)
spectrogram(V_flutterfilt, 60,0,60,360, 'yaxis')
title("Spectrogram of Ventricular Flutter 3 window size 60");
set(gca,'FontName','Times New Roman','FontSize',18);
%ylim([0 30])

subplot(3,1,2)
spectrogram(V_flutterfilt, 360,0,360,360, 'yaxis')
title("Spectrogram of Ventricular Flutter 3 with window 360");
set(gca,'FontName','Times New Roman','FontSize',18);

subplot(3,1,3)
spectrogram(V_flutterfilt, 720,0,720,360, 'yaxis')
title("Spectrogram of Ventricular Flutter 3 with window 720");
set(gca,'FontName','Times New Roman','FontSize',18);

% Supraventricular Tachyarrythmia 1
figure (4)
subplot(3,1,1)
spectrogram(SV_tachyarrythmiafilt, 60,0,60,360, 'yaxis')
title("Spectrogram of Supraventricular Tachyarrythmia 1 window size 60");
set(gca,'FontName','Times New Roman','FontSize',18);
%ylim([0 30])

subplot(3,1,2)
spectrogram(SV_tachyarrythmiafilt, 360,0,360,360, 'yaxis')
title("Spectrogram of Supraventricular Tachyarrythmia 1 with window 360");
set(gca,'FontName','Times New Roman','FontSize',18);

subplot(3,1,3)
spectrogram(SV_tachyarrythmiafilt, 720,0,720,360, 'yaxis')
title("Spectrogram of Supraventricular Tachyarrythmia 1 with window 720");
set(gca,'FontName','Times New Roman','FontSize',18);