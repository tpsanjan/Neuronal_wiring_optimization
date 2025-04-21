function [ dL ] = delta_length( neuron, new_pos, old_pos, positions, adj_mat, fixed_pt_sets )
%DELTA_LENGTH Find the length change in one SA move.
    dL = 0;
    N = size(positions,1);
    for i = 1:N,
        % Other neurons.
        o_pos = positions(i,:);
        if adj_mat(neuron, i),
            dL = dL + (norm(double(new_pos) - o_pos) - norm(double(old_pos) - o_pos));
        end
        
        if adj_mat(i, neuron),
            dL = dL + (norm(double(new_pos) - o_pos) - norm(double(old_pos) - o_pos));
        end
    end
    
    % Sensors, NMJs etc.
    fps = fixed_pt_sets{neuron};
    for i = 1:size(fps,1),
        dL = dL + (norm(double(new_pos) - fps(i,:)) - norm(double(old_pos) - fps(i,:)));
    end
end