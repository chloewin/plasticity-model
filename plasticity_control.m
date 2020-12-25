% This code explores the data collected under control conditions for each stimulation frequency.
% Variables listed can be changed to explore the model's fit of the collected data.
% In the end of this code, the postsynaptic voltage predicted by the model and 
% collected in the experiments are plotted against each other.
% Additionally, for the sake of exploration, the probability of release, ratio of readily
% releasable vesicles, and calcium concentration are plotted over time for each stimulation frequency.

clear all;

% Load data
data_5 = xlsread('control_5hz.xlsx');
data_10 = xlsread('control_10hz.xlsx');
data_20 = xlsread('control_20hz.xlsx');
data_50 = xlsread('control_50hz.xlsx');

% Time variables
%   dt: timestep duration for use in Euler's method
%    T: total simulation time in ms
dt = 0.1;
T = 3000; 

% Set-up
npoints = T / dt;
spikes = zeros(4, npoints);

% Development of spikes vector based on background stimulation
%   bckgd_freq: frequency of background stimulation (Hz)
%    stim_freq: all tested stimulation frequencies (Hz)
%    ap_length: number of timesteps of action potential used for simulation
%               purposes
%  stim_length: duration of high-frequency stimulation (ms)
bckgd_freq = 1; 
period = 1000 / bckgd_freq;
stim_freq = [5 10 20 40];
ap_length = 2 / dt; 
stim_length = [603 600 460 340];

stim_start = 1;
stim_period = 1000 ./ stim_freq;

for n = 1:4; % put spikes = 1 every other period ms
    for index = 1:1 + stim_length(n) / dt; % high frequency spikes
        if mod(index - stim_start, stim_period(n) / dt) == 0;
            spikes(n, index:index+ap_length-1) = ones(ap_length, 1);
        end;
    end;
    for index = 1 + stim_length(n) / dt:npoints; % background spikes
        if mod(index - 1 - stim_length(n), period / dt) == 0;
            spikes(n,index:index+ap_length-1) = ones(ap_length, 1);
        end;
    end;
end;

time = zeros(npoints, 1);

% calcium vector and parameters
%      Ca_0: initial calcium concentration (uM)
%   gain_Ca: increase in calcium concentration per action potential
%   loss_Ca: steady state rate of calcium efflux [could also experiment
%   with tau_Ca which is meant to be the time constant of decay of [Ca]]
Ca_0 = .2137; %.75;
gain_Ca = .3529; %.1;
%tau_Ca = 500;
loss_Ca = .0063;

Ca = zeros(4,npoints); % will be used to keep track of [Ca] over time for each stimulation frequency
Ca(:,1) = Ca_0;

% readily releasable vesicle pool vector and parameters
%   k_recov: rate of vesicle recovery (ms-1) as described in Lee, et al.
k_recov = 1; %0.052;

r_rel = zeros(4, npoints); % will be used to keep track of readily releasable ratio
r_rel(:,1) = 1;

% postsynaptic voltage vector and parameters
%      vesicles: total number of vesicles
%  amp_baseline: baseline amplitude of postsynaptic potentials (from
%  background stimulation)
%          k_nt: neurotransmitter influx per action potential (uM/s)
%         tau_v: postsynaptic membrane time constant
vesicles = 100;
ampl_baseline = mean([4.06, 5.0, 3.49, 5.3]) * ones(1,4);
k_nt = 0.1;
%ampl_baseline = [4.06 5 3.49 5.3];
%ampl_baseline = 4.5;%43.7105; %50.1; % product of k_nt and vesicles
tau_v = 60.0313; %40;

psp = zeros(4, npoints); % used to keep track of psp over time

% release probability vector and parameters
%                   L, m, mid: parameters for sigmoid function of calcium concentration
%     k_rel, n_hill, p_relmax: parameters for Hill equation
k = 1;
L = 1;
m = 8; % steepness;
mid = 0.5; % midpoint Ca
n_hill = 4;
k_rel = 9;
p_relmax = .4597; %1; % 0.9

p_rel = zeros(4, npoints); % will be used to track p_rel over time

% simulation: commented out lines describe alternative models
for n = 1:4;
    for step=1:npoints-1,    
        time(step+1)=time(step)+dt;

        % calcium
        Ca(n,step + 1) = Ca(n,step) - loss_Ca * dt + gain_Ca * spikes(n,step) * dt; % "Linear" decay model
%         if spikes(n, step) == 1;
%             Ca(n, step+1) = Ca(n, step) + gain_Ca;
%         else;
%             Ca(n, step + 1) = Ca(n, step) - .00001;
%         end;
        %Ca(n, step + 1) = Ca(n,step) + (0 - Ca(n,step) / tau_Ca + Ca_0 /
        %tau_Ca + gain_Ca * spikes(n,step)) * dt; % Exponential decay model

        % p_rel
        p_rel(n,step) = 1 / (1 + exp(8 * .5 - 8 * Ca(n,step))); % Sigmoid model with fixed numbers
        %p_rel(n,step) = L / (1 + exp(m * mid - m * Ca(n,step))); %
        %Parameterized sigmoid model
        %p_rel(n,step) = p_relmax * (Ca(n,step) ^ n_hill) / ((Ca(n,step) ^
        %n_hill) + (k_rel ^ n_hill)); % Hill equation
        
        % r_rel
        %r_rel(n,step + 1) = r_rel(n,step) + dt * (k_recov * (1 -
        %r_rel(n,step)) - .7 * p_rel(n,step) * r_rel(n,step) *
        %spikes(n,step)); % Model with fixed numbers
        r_rel(n,step + 1) = r_rel(n,step) + dt * (k_recov * (1 - r_rel(n,step)) - p_rel(n,step) * r_rel(n,step) * spikes(n,step)); % Parameterized model
        
        p_rel(n,step) * r_rel(n,step) * spikes(n,step);
        
        % psp voltage
        %psp(step + 1) = psp(step) - dt * ((psp(step) / tau_v) - (k_nt *
        %vesicles/tau_v) * p_rel(step) * r_rel(step) * spikes(step)); %
        %General model 
        psp(n,step + 1) = psp(n,step) - dt * ((psp(n,step) / tau_v) - (ampl_baseline(n)) * p_rel(n,step) * r_rel(n,step) * spikes(n,step)); % Model with experimentally found baseline amplitudes       
        %psp(n,step + 1) = psp(n,step) - dt * ((psp(n,step) / tau_v) - (ampl_baseline) * p_rel(n,step) * r_rel(n,step)* spikes(n,step)); %);
    end;
end;

% plotting
data = [data_5(:, 1:2) data_10(:, 1:2) data_20(:, 1:2) data_50(:, 1:2)];
baseline = [-45.46 -45.94 -46.89 -47.47];
titles = ["5 Hz stimulation", "10 Hz stimulation", "20 Hz stimulation", "50 Hz stimulation"];
for n = 1:4;
    psp(n,:) = psp(n,:) + baseline(n) * ones(1,npoints);
    subplot(2, 2, n);
    plot(time, psp(n, :), .1:.1:3000, data(:, 2 * n));
    legend('model', 'real');
    title(titles(n));
    xlabel("time (ms)");
    ylabel("postsynaptic voltage (mV)");
end
figure, plot(time, p_rel);
legend("5 Hz stimulation", "10 Hz stimulation", "20 Hz stimulation", "50 Hz stimulation");
title("Release Probability Over Time");
xlabel("time (ms)");
ylabel("release probability");

figure, plot(time, r_rel);
legend("5 Hz stimulation", "10 Hz stimulation", "20 Hz stimulation", "50 Hz stimulation");
title("Readily Releasable Ratio Over Time");
xlabel("time (ms)");
ylabel("releasable ratio");

figure, plot(time, Ca);
legend("5 Hz stimulation", "10 Hz stimulation", "20 Hz stimulation", "50 Hz stimulation");
title("Calcium Concentration Over Time");
xlabel("time (ms)");
ylabel("[Ca]");