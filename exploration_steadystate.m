% This code plots the average release probability and the neurotransmission rate as a function of
% stimulation frequency. The transmission rate is computed as the release
% probability multiplied by the stimulation frequency because this
% represents on average the frequenc at which neurotransmitter will be
% released (since the probability is nonzero only when there is
% stimulation.)

stim_freq = 0:1:100;

p_rel = zeros(1, length(stim_freq));
trans_rate = zeros(1, length(stim_freq));

for index = 1:length(stim_freq)
    p_rel_vec = calc_prel(1, 200, 0.5, stim_freq(index), 500);
    p_rel(index) = mean(p_rel_vec);
    trans_rate(index) = mean(p_rel_vec) * stim_freq(index);
end;


plot(stim_freq, p_rel)
hold on;
yyaxis left
xlabel("input firing rate (Hz)", 'FontName', 'courier');
ylabel('average release probability', 'FontName', 'courier');

yyaxis right
plot(stim_freq, trans_rate)
ylabel('average transmission rate', 'FontName', 'courier');
