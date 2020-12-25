% This code plots the release probability over time where the cell is being
% stimulated at 100 Hz initially, then 3.2 Hz, and finally 40 Hz.

clear all;
figure;
hold on;
%p_rel = [movmean(calc_prel(0.8, 200, 0.5, 25, 200),9000).' movmean(calc_prel(0.8, 200, 0.5, 100, 300), 9000).' movmean(calc_prel(0.8, 200, 0.5, 10, 500), 9000).' movmean(calc_prel(0.8, 200, 0.5, 40, 200),9000).'];
p_rel = movmean(8 * calc_prel(0.8, 300, 0.5, 8, 200),5000).';
xline(length(p_rel)/100);
p_rel = [p_rel movmean(100 * calc_prel(0.8, 300, 0.5, 100, 300), 7500).'];
xline(length(p_rel)/100);
p_rel = [p_rel movmean(3.2 * calc_prel(0.8, 300, 0.5, 3.2, 700), 17500).'];
xline(length(p_rel)/100);
p_rel = [p_rel movmean(40 * calc_prel(0.8, 300, 0.5, 40, 200), 5000).'];
xline(length(p_rel)/100);
p_rel_slide = movmean(p_rel,4000);
time = 0:length(p_rel) - 1;
time = time / 100
plot(time, p_rel);
title('Dynamic Response to Firing Rates', 'FontName', 'courier');
xlabel('time (ms)', 'FontName', 'courier');
ylabel('average transmission rate (Hz)', 'FontName', 'courier');

% dt = 50;
% stim_freq = [25 * ones(1, 200 / dt) 100 * ones(1, 300 / dt) 10 * ones(1, 500 / dt) 40 * ones(1, 200 / dt)];
% p_rel = zeros(1, length(stim_freq));
% trans_rate = zeros(1, length(stim_freq));
% last_p_rel = zeros(1, 1000);
% % sum = 0;
% % num = 0;
% 
% last_freq = -1;
% for index = 1:length(stim_freq);
% %     if stim_freq(index) == last_freq;
% %         p_rel(index) = mean(last_p_rel(1:min(dt / 0.01, length(last_p_rel))));
% %         trans_rate(index) = p_rel(index) * stim_freq(index);
% %         last_p_rel = last_p_rel(dt / 0.01 + 1:end);
% %     else;
% %         last_freq = stim_freq(index);
% %         last_p_rel = calc_prel(0.8, 200, 0.5, last_freq, 1000);
% %         p_rel(index) = mean(last_p_rel(1:dt / 0.01));
% %         trans_rate(index) = p_rel(index) * stim_freq(index);
% %         last_p_rel = last_p_rel(dt / 0.01 + 1:end);
% %     end;
% end;
        
    
% for index = 1:length(stim_freq)
%     p_rel_vec = calc_prel(last_p_rel, 200, 0.5, stim_freq(index));
%     p_rel(index) = mean(p_rel_vec);
%     last_p_rel = mean(p_rel_vec);
%     trans_rate(index) = mean(p_rel_vec) * stim_freq(index);
% end;

% plot(1:length(stim_freq), p_rel)
% hold on;
% yyaxis left
% % xlabel("rate (Hz)", 'FontName', 'courier');
% % ylabel('average release', 'FontName', 'courier');
% % 
% % yyaxis right
% plot(1:length(stim_freq), trans_rate)
% ylabel('average transmission', 'FontName', 'courier');
% legend("average release", "average transmission");