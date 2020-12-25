function psp = generate_plastic_voltage(v_0,Ca_0, gain_Ca, loss_Ca, k_recov, ampl_baseline, tau_v, p_relmax);
% Predicts voltage trace assuming plasticity
% Please refer to plasticity_control.m for a walkthrough of the math
% Accepts following parameters
%       v_0: starting postsynaptic voltage
%      Ca_0: starting [Ca] in uM
%   gain_Ca: Ca influx at action potential
%   loss_Ca: Ca efflux
%   k_recov: recovery time constant for vesicles
% ampl_baseline: baseline postsynaptic potential amplitude (before
% plasticity occurs) in mV
%     tau_v: membrane time constant
%  p_relmax: maximum release probability (used for Hill equation)

    bckgd_freq = 1;
    stim_freq = 10;
    period = 1000 / bckgd_freq; % ms
    dt = 0.1;
    stim_length = 1600;
    T = stim_length * 1; % ms
    npoints = T / dt;

    spikes = zeros(npoints, 1);
    ap_length = 2 / dt; 

    stim_start = 1;
    stim_period = 1000 / stim_freq;
    for index = stim_start:stim_start + stim_length / dt;
        if mod(index - stim_start, stim_period / dt) == 0;
            spikes(index:index+ap_length-1) = ones(ap_length, 1);
        end;
    end;
    
    time = zeros(npoints, 1);

    % calcium vector and parameters
    % Ca_0 = 4.7;
    % gain_Ca = 120;
    % tau_Ca = 150;

    Ca = zeros(npoints, 1);
    Ca(1) = Ca_0;

    % readily releasable vesicle pool vector and parameters
    % k_recov = 0.22;

    r_rel = zeros(npoints, 1);
    r_rel(1) = 1;

    % postsynaptic voltage vector and parameters
    vesicles = 100;
    k_nt = 0.1;
    % ampl_baseline = 3.91; % product of k_nt and vesicles
    % tau_v = 40;

    psp = zeros(npoints, 1);
    psp(1) = 0;

    % release probability vector and parameters
    % k = 0.01;
    % L = 1;
    % m = 8; % steepness;
    % n = 0.5; % midpoint Ca
    n_hill = 4;
    % k_rel = 9;
    % p_relmax = 1; % 0.9

    p_rel = zeros(npoints, 1);

    % differentiation
    for step=1:npoints-1,    
        time(step+1)=time(step)+dt;

        % calcium
        %Ca(step + 1) = Ca(step) + (0 - Ca(step) / tau_Ca + Ca_0 / tau_Ca + gain_Ca * spikes(step)) * dt;
        Ca(step + 1) = Ca(step) - loss_Ca * dt + gain_Ca * spikes(step) * dt;
        
        % p_rel
        p_rel(step) = 1 / (1 + exp(8 * .5 - 8 * Ca(step)));
        %p_rel(step) = p_relmax * (Ca(step) ^ n_hill) / ((Ca(step) ^ n_hill) + (k_rel ^ n_hill));

        % r_rel
        r_rel(step + 1) = r_rel(step) + dt * (k_recov * (1 - r_rel(step)) - p_rel(step) * r_rel(step) * spikes(step));

        % psp voltage
        %psp(step + 1) = psp(step) - dt * ((psp(step) / tau_v) - (k_nt * vesicles/tau_v) * p_rel(step) * r_rel(step) * spikes(step));
        psp(step + 1) = psp(step) - dt * ((psp(step) / tau_v) - (ampl_baseline) * p_rel(step) * r_rel(step) * spikes(step));
        p_rel(step) * r_rel(step) * spikes(step);
    end;

    %sigmoid
    % Ca_vals = 0:0.1:1;
    % p_rel_vals = zeros(length(Ca_vals), 1);
    % for index = 1:length(Ca_vals);
    %     p_rel_vals(index) = L / (1 + exp(m * n - m * Ca_vals(index)));
    % end;
    % plot(Ca_vals, p_rel_vals);
    
    psp = psp + v_0 * ones(npoints, 1);
end