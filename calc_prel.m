function p_rel = calc_prel(p_0, tau_p, fd, stim_freq, delta_time);
% Computes release probability over time given parameters.
%       p_0: starting release probability
%     tau_p: time constant for release probability decay
%        fd: growth factor for release probability
% stim_freq: frequency of high-freqeuncy stimulation
%delta_time: duration of simulation

    %npoints=50000;  %number of timesteps to integrate
    dt=0.01;        %timestep
    npoints = delta_time / dt;
    
    stim_freq = stim_freq / 1000; % freq in ms
    period = (1 / stim_freq); % ms

    p_rel=zeros(npoints,1);
    time=zeros(npoints,1);

    p_rel(1)=p_0;
    time(1)=0.0; % each unit will correspond to dt ms

    multiplier = 1 / dt;
    tic
    for step=1:npoints-1,
        %if mod(time(step) * 100, period * 100) == 0;
        %if floor(time(step) / period) == time(step) / period;
        if mod(time(step), floor(period * multiplier)) == 0; % floor accounts for the rounding errors in this product
            p_rel(step+1) = (1 + fd) * p_rel(step);
        else;
            p_rel(step+1)=p_rel(step)+(((p_0 - p_rel(step))/tau_p))*dt;
        end;
        time(step+1)=time(step)+(multiplier * dt);
    end
    toc

%     set(0,'defaultaxesfontsize',20);
%     set(0,'defaulttextfontsize',20); 
% 
%     figure
%     plot(time / multiplier, p_rel);
%     xlabel('t');
%     ylabel('prel');

    % figure(2)
    % subplot(2,1,1);
    % plot(time(10001:11500),v(10001:11500));
    % xlabel('t');
    % ylabel('V');
    % subplot(2,1,2);
    % hold on;
    % plot(time(10001:11500),n(10001:11500));
    % plot(time(10001:11500),m(10001:11500),'--');
    % plot(time(10001:11500),h(10001:11500),':');
    % xlabel('t');
    % ylabel('n,m,h');
end