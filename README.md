# Biosignals_ECG_signalprocessing

Biomedical Signal Processing
Lab 3 : Acquisition and Analysis of Electrocardiogram Signals

Submission date: March 28 th 2021

Gavin Rotsaert-Smith

## Exercise 1: Einthoven’s Law
<img width="927" alt="image" src="https://user-images.githubusercontent.com/70657001/168645660-24af94bd-f734-4e3c-b5ad-58fb03d739d4.png">

Figure 1: First 4 beats of sitting and laying ECG signals from Lead I

Using figure 1 the heart rate was calculated by averaging the time difference between R complexes of each beat as seen in figure 2. The inverse of this time would give us the heart rate
and multiplying it by 60s gives the heart rate in beats per minute. The heart rate of sitting and laying were 82bpm and 58bpm respectively.

Using the first four beats from figure 2 Lead II was calculated using Einthoven’s Law:

LEAD II = LEAD I + LEAD III

***Equation 1: Einthoven’s Law
<img width="916" alt="image" src="https://user-images.githubusercontent.com/70657001/168645727-441a03e9-7ba4-4cbe-86c7-2e47a8b75f8c.png">

***Figure 2: Sitting ECG and Laying ECG Calculated vs Real for Lead II
<img width="807" alt="image" src="https://user-images.githubusercontent.com/70657001/168645851-331c7f53-41e3-465b-a31f-92137e97e5b6.png">

***Figure 3: Mean Squared Error over time for Sitting and Laying Calculated vs Real (Lead II)

Figure 2 shows the real versus the calculated ECG signal for lead II. There is a small difference between the calculated and real. The error was calculated for each of these signals and can be seen in figure 4. The mean squared error was calculated between the calculated lead II and actual lead II. The mean squared error for sitting was 0.001 and 0.0001 for the laying ECG.

Artifacts were created by moving the right or left arm. The left arm artifacts have an effect on leads I and III based on Einthoven’s Triangle which can be seen in figure 5. The leads are obtained using this triangle and each lead can be seen in equation 2 where LA is the left arm, RA is the right arm and LL is the left leg.
<img width="321" alt="image" src="https://user-images.githubusercontent.com/70657001/168645901-beff53be-7a53-44e2-9d99-997dc2e02613.png">

***Figure 4: Einthoven’s Triangle

***LEAD I = LA – RA
LEAD II = LL – RA
LEAD III = LL – LA ***

***Equation 2: Einthoven’s Leads calculated from Einthoven’s Triangle

Since leads I and III require the left arm electrode they are expected to experience noise artifacts. The right arm artifacts are therefore present in leads I and II based on Einthoven’s Triangle. The frequency components of the artifacts can be seen in figure 6 for the left arm. To recover the missing data the leads with distortion can be used to model the artifacts. To do this for the left arm lead I is subtracted from lead III and divided by 2. For the right arm lead I is added to lead II and divided by 2. The opposite signs are due to the artifacts being mirrors of each other as seen in Einthoven’s Triangle in figure 5. The error is then subtracted from the noisy signals. The results can be seen in figure 7 for lead I.

Left arm sample calculation
ERROR = (LEAD I – LEAD III)/
LEAD I = LEAD I -ERROR
LEAD III = LEAD III – ERROR

Right arm sample calculation
ERROR = (LEAD I + LEAD II)/
LEAD I = LEAD I – ERROR
LEAD II = LEAD II – ERROR
<img width="605" alt="image" src="https://user-images.githubusercontent.com/70657001/168646064-d84568bb-c160-4c46-88df-bb0e281a3c92.png">

***Figure 6: Frequency domain of the left arm artifacts leads
<img width="831" alt="image" src="https://user-images.githubusercontent.com/70657001/168646109-3a9b9935-3be3-4aa0-bc9a-719bc7890802.png">

***Figure 7 : Left and Right arm clean vs artifact signal for Lead I

## Exercise 2: Filtering the ECG

Lowpass Filtering

The Butterworth filter designed has a cutoff frequency of 20Hz with an order of 10.
<img width="841" alt="image" src="https://user-images.githubusercontent.com/70657001/168646166-1aa0ec86-084e-42bf-aa94-14be568f921f.png">

***Figure 8: Magnitude and Phase Response of Butterworth filter

The Hanning filter has a window size of 30 and a cutoff frequency of 20Hz.
<img width="852" alt="image" src="https://user-images.githubusercontent.com/70657001/168646203-4fbbbce8-c9bb-4c91-b257-88c77144ea21.png">

***Figure 9: Magnitude and Phase Response of Hanning filter

A Hanning filter with a window size of 30 was used. The Hanning filter increased the gain after filtering. To adjust the gain the numerator coefficients (bhann) were divided by the sum of the numerator coefficients.

Code for Hanning filter
bhann = hann(30);

bhann = bhann/sum(bhann);

ahann = zeros(1,length(bhann));
ahann(1,1) = 1;
<img width="854" alt="image" src="https://user-images.githubusercontent.com/70657001/168646247-f2bd5a19-91d3-4fb6-8232-6651d5c0d4fa.png">

***Figure 10: Sitting Butterworth and Hanning filtered vs unfiltered for leads I, II, III
<img width="846" alt="image" src="https://user-images.githubusercontent.com/70657001/168646281-95944abf-3db8-45b0-9cf5-1ab337829258.png">

***Figure 11 : Laying Butterworth and Hanning filtered vs unfiltered for leads I, II, III
<img width="822" alt="image" src="https://user-images.githubusercontent.com/70657001/168646315-38b3cadb-b1cf-42b8-85cf-a83ea0f48ccd.png">

Figure 12: Sitting difference in filtered vs unfiltered ECG signals for Leads I, II, III
<img width="921" alt="image" src="https://user-images.githubusercontent.com/70657001/168646335-220b367a-281b-4a85-9885-6cae67eab257.png">

***Figure 13 : Laying difference in filtered vs unfiltered ECG signals for Leads I, II, III

***Table 1: SNR for Butterworth and Hanning filters for Leads I, II, III

SNR (dB) Lead I Lead II Lead III
Filter Butterworth Hanning Butterworth Hanning Butterworth Hanning
Sitting - 1.29 - 2.38 - 1.00 - 1.98 - 1.19 - 1.
Laying - 0.893 - 1.59 - 0.645 - 1.45 - 0.523 - 0.

From figures 10 and 11 it is clear that the 10th order Butterworth filter has less distortion on the PQRST waves. If the order of the Butterworth filter was reduced to 2 then it is expected that the Hanning filter would have better performance. This is also evident in figures 12 and 13 where the difference between the unfiltered and filtered signals is greater for the Hanning filter than the Butterworth filter. Based on the signal to noise ratio (SNR) in table 1 the SNR is on average higher for the Hanning filter when compared to the Butterworth filter. A larger SNR (less than 1) means that there is more noise than signal, both the Butterworth and Hanning have more noise than signal but the Butterworth’s SNR is closer to 0 than the Hanning therefore the Butterworth is performing better.

## Notch Filtering

Based on the transfer function derived in the pre-lab, the coefficients of b and a can be seen in the following code:

function [filt_dat] = notchfilt(data)

%from pre lab
b = [0.995,-1.6099,0.995];
a = [1,-1.6019,0.9801];

%applying filter
filt_dat = filtfilt(b,a,data);
end
<img width="859" alt="image" src="https://user-images.githubusercontent.com/70657001/168646512-be58e0eb-f525-433c-b4f5-163a540ac255.png">

***Figure 14: Magnitude and Phase response of the notch filter
<img width="804" alt="image" src="https://user-images.githubusercontent.com/70657001/168646537-4ba5fb43-6950-43c5-95dc-7f696a507074.png">

***Figure 15: Filtered vs Unfiltered Notch filter time domain
<img width="672" alt="image" src="https://user-images.githubusercontent.com/70657001/168646583-880cf0ab-2cac-4c5c-849f-f152d49698d4.png">

***Figure 16: Filtered vs Unfiltered Notch filter frequency domain

The notch filter was designed with a notch frequency of 60Hz. From figure 15 it is hard to tell the difference from the filtered and unfiltered data, when it is examined in the frequency domain it is clear that the noise at 60Hz (power line interference) has been removed from the signal.

## Time-Frequency Analysis of Cardiac Abnormalities
<img width="838" alt="image" src="https://user-images.githubusercontent.com/70657001/168646666-27c44d4b-0824-495d-ac7c-e27b39740f0b.png">

***Figure 17: A few seconds of the Normal sinus rhythm, Ventricular Trigeminy, Ventricular
Flutter and Supraventricular Tachyarrhythmia
<img width="894" alt="image" src="https://user-images.githubusercontent.com/70657001/168646688-81250339-362e-4dc2-867f-2b4cba4e8cb9.png">

***Figure 18: Filtered vs Unfiltered Normal sinus rhythm, Ventricular Trigeminy, Ventricular
Flutter and Supraventricular Tachyarrhythmia

The filter used for to filter out the baseline drift was a 10th order high pass Butterworth filter with a cutoff frequency of 18Hz. The Butterworth was chosen as it worked well when filtering the previous ECG signals without disrupting the PQRST complex’s. The filtered and unfiltered data can be seen in figure 18.
<img width="839" alt="image" src="https://user-images.githubusercontent.com/70657001/168646724-7a63fe06-d5c6-401d-a1f3-ffa5cb25bb5c.png">

    ***Figure 19: Spectrogram of Normal Sinus Rhythm at window sizes of 60, 360 and
    <img width="852" alt="image" src="https://user-images.githubusercontent.com/70657001/168646752-3ae09851-2545-44f5-a1a0-d5cf3da33859.png">

    ***Figure 20: Spectrogram Ventricular Trigeminy at window sizes of 60, 360 and
<img width="844" alt="image" src="https://user-images.githubusercontent.com/70657001/168646791-c5cf60c3-2e8e-43a2-8f6f-765654b5830f.png">

***Figure 21: Spectrogram of Ventricular Flutter at window sizes of 60, 360 and 720
<img width="846" alt="image" src="https://user-images.githubusercontent.com/70657001/168646819-dabebfe8-b0f8-4e6d-815c-6eb9b0b33c89.png">

***Figure 22: Spectrogram of Supraventricular Tachyarrhythmia at window sizes of 60, 360 and
720

Based on the spectrograms in figures 19-22 as the window size increases the detail of the signal decreases, therefore increasing the window size will decrease the frequency resolution of the spectrogram.
