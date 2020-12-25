function cost = calc_cost(input); 
    % param input: [v_0, Ca_0, gain_Ca, tau_Ca, k_recov, ampl_baseline, tau_v, p_relmax]
    %       v_0: starting postsynaptic voltage
    %      Ca_0: starting [Ca] in uM
    %   gain_Ca: Ca influx at action potential
    %   loss_Ca: Ca efflux
    %   k_recov: recovery time constant for vesicles
    % ampl_baseline: baseline postsynaptic potential amplitude (before
    % plasticity occurs) in mV
    %     tau_v: membrane time constant
    %  p_relmax: maximum release probability (used for Hill equation)
    %      return: L2 norm of difference between actual voltages and predicted voltage
    real_data = csvread('10hz_burst_psp.csv');
    v_real = real_data(:, 2);
    v_0 = v_real(1)
    
    Ca_0 = input(2);
    input
    %Ca_0 = 0;
    gain_Ca = input(3);
    loss_Ca = input(4);
    k_recov = input(5);
    ampl_baseline = input(6);
    ampl_baseline = 4.5;
    tau_v = input(7);
    p_relmax = input(8);
    
    v_sim = generate_plastic_voltage(v_0, Ca_0, gain_Ca, loss_Ca, k_recov, ampl_baseline, tau_v, p_relmax);
    len = min(length(v_sim), length(v_real));
    v_real = v_real(1:len);
    
    cost = (v_sim - v_real).' * (v_sim - v_real)
    %figure,plot(1:len, v_sim, 1:len, v_real)
    %figure, plot(1:length(v_sim), v_sim, 1:length(v_real), v_real);
end