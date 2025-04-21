function [ container, L, positions ] = SARearrangement( container, init_pos, init_assgn, free_neurons,...
                                adj_mat, fixed_pt_sets)
%SAREARRANGEMENT Runs simulated annealing to compute optimal neuron
%placement.
    init_T = 1e10;
    T_min = 1e-300;

    T = init_T;
    positions = init_pos;
    box_assgn = init_assgn;

    L = [total_length(positions, adj_mat, fixed_pt_sets)];
    
    T_print_freq = 100000;
    T_last_printed = 0;
    T_print_cycles = 0;
    while T > T_min,
        if T_last_printed == T_print_freq,
            display(T);
            T_last_printed = 0;
            T_print_cycles = T_print_cycles + 1;
        end
        T_last_printed = T_last_printed + 1;

        [neuron_to_move, new_pos] = move_positions(container,...
                                                   positions,...
                                                   box_assgn,...
                                                   free_neurons);

        old_pos = positions(neuron_to_move, :);
        dL = delta_length(neuron_to_move, new_pos, old_pos, positions, adj_mat, ...
                          fixed_pt_sets);
        L = [L; L(end) + dL];
        p = accept_prob(dL, T);

        if rand() < p,
            % accept
            positions(neuron_to_move,:) = new_pos;
            old_box = pos2box(old_pos, container.x_cwidth, container.y_cwidth);
            old_row = old_box(1); old_col = old_box(2);
            new_box = pos2box(new_pos, container.x_cwidth, container.y_cwidth);
            new_row = new_box(1); new_col = new_box(2);
            box_assgn(neuron_to_move,:) = new_box;        
            old_contents = container.box_contents{old_row, old_col};
            container.box_contents{old_row, old_col} = ...
                    old_contents(old_contents ~= neuron_to_move);
            container.box_contents{new_row, new_col} = ...
                    [container.box_contents{new_row, new_col}; neuron_to_move];
        else
            L(end) = L(end) - dL; % undo the change.
        end

        T = temp_update(T);
    end
end