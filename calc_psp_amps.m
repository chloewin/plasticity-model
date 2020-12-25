function amps = calc_psp_amps(v)
% This code detects and computes the amplitude of postsynaptic potentials
% given the postsynaptic voltage over time. This identifies peaks based on
% a change in increasing/decreasing. Please note that this method would
% assume that postsynaptic potentials are relatively clearly defined.
    threshold = .1;
    amps_raw = [];
    
    last_min = v(1);
    first_v = v(1);
    second_v = v(1);
    third_v = v(1);
    last_v = v(1);
    
    for index = 2:length(v)
        if v(index) ~= last_v
            if first_v == second_v
                second_v = v(index);
                third_v = v(index);
            elseif second_v == third_v
                third_v = v(index);
            end
            last_v = v(index);
        end
        % if all vs are ready and different
        if first_v ~= second_v & second_v ~= third_v
            % if minimum
            if second_v < third_v && second_v < first_v
                last_min = second_v;
            % if maximum
            elseif second_v > third_v && second_v > first_v
                amps_raw = [amps_raw abs(second_v - last_min)];
            end
            
            first_v = second_v;
            second_v = third_v;
        end
    end
    
    amps = [];
    for index = 1:length(amps_raw);
        if amps_raw(index) > threshold;
            amps = [amps amps_raw(index)];
        end;
    end;
end
                
                