function cost = calc_psp_amp_cost(inputs);
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
    % return: L2 norm of difference between predicted and real amplitudes
    
    data_5 = xlsread('control_5hz.xlsx');
    %data_10 = xlsread('control_10hz.xlsx');
    data_20 = xlsread('control_20hz.xlsx');
    data_50 = xlsread('control_50hz.xlsx');
    
    amps_real_5 = calc_psp_amps(data_5(:,2));
    %amps_real_10 = calc_psp_amps(data_10(:,2));
    amps_real_20 = calc_psp_amps(data_20(:,2));
    amps_real_50 = calc_psp_amps(data_50(:,2));

    stim_length = [603 600 460 340];    
    stim_length = [903 900 630 420];
    amps_predicted_5 = predict_psp_amps(5, stim_length(1), amps_real_5(1), inputs(1), inputs(2), inputs(3), inputs(4), inputs(5), inputs(6), inputs(7))
    %amps_predicted_10 = predict_psp_amps(10, stim_length(2), amps_real_10(1), inputs(1), inputs(2), inputs(3), inputs(4), inputs(5), inputs(6), inputs(7));
    amps_predicted_20 = predict_psp_amps(20, stim_length(3), amps_real_20(1), inputs(1), inputs(2), inputs(3), inputs(4), inputs(5), inputs(6), inputs(7))
    amps_predicted_50 = predict_psp_amps(50, stim_length(4), amps_real_50(1), inputs(1), inputs(2), inputs(3), inputs(4), inputs(5), inputs(6), inputs(7))
    
    % make equal lengths
    maxlen = max(length(amps_predicted_5), length(amps_real_5));
    amps_predicted_5(end+1:maxlen) = 0;
    amps_real_5(end+1:maxlen) = 0;
    maxlen = max(length(amps_predicted_20), length(amps_real_20));
    amps_predicted_20(end+1:maxlen) = 0;
    amps_real_20(end+1:maxlen) = 0;
    maxlen = max(length(amps_predicted_50), length(amps_real_50));
    amps_predicted_50(end+1:maxlen) = 0;
    amps_real_50(end+1:maxlen) = 0;
    
    % sqred_errors = (amps_predicted_10 - amps_real_10) .* (amps_predicted_10 - amps_real_10); 
    sqred_errors_5 = (amps_predicted_5 - amps_real_5) .* (amps_predicted_5 - amps_real_5);
    cost_5 = sum(sqred_errors_5)/length(amps_predicted_5); 
    sqred_errors_20 = (amps_predicted_20 - amps_real_20) .* (amps_predicted_20 - amps_real_20);
    cost_20 = sum(sqred_errors_20)/length(amps_predicted_20);
    sqred_errors_50 = (amps_predicted_50 - amps_real_50) .* (amps_predicted_50 - amps_real_50);
    cost_50 = sum(sqred_errors_50)/length(amps_predicted_50);

    cost = cost_5 + cost_20 + cost_50;
    
%     amps_real = containers.Map([5, 10, 20, 50], [sprintf(calc_psp_amps(data_5(:,2))),sprintf(calc_psp_amps(data_10(:,2))),sprintf(calc_psp_amps(data_20(:,2))),sprintf(calc_psp_amps(data_50(:,2)))]);
%     amps_predicted = containers.Map([5, 10, 20, 50], [predict_psp_amps(5, inputs(2), inputs(3), inputs(4), inputs(5), inputs(6), inputs(7), inputs(8), inputs(9)); predict_psp_amps(10, inputs(2), inputs(3), inputs(4), inputs(5), inputs(6), inputs(7), inputs(8), inputs(9)); predict_psp_amps(20, inputs(2), inputs(3), inputs(4), inputs(5), inputs(6), inputs(7), inputs(8), inputs(9)); predict_psp_amps(50, inputs(2), inputs(3), inputs(4), inputs(5), inputs(6), inputs(7), inputs(8), inputs(9))]);
    
end