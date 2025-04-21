function [ neuron_to_shift, new_pos ] = ...
                    move_positions( container,...
                                    positions, ...
                                    box_assgn,...
                                    free_neurons)
%MOVE_POSITIONS Move 1 neuron among the free neurons randomly, keeping 
%   constraints in mind.
%
%   Choose a neuron randomly; if its box has just the minimum number of neurons in
%   it, move the neuron inside the box itself.
%   If there is an excess, take the neuron and place it anywhere.
%   ANYWHERE! But keep constraints in mind.    
    N = size(positions, 1);
    
    neuron_to_shift = randsample(free_neurons,1);
    neuron_box = box_assgn(neuron_to_shift,:);
    row = neuron_box(1); col = neuron_box(2);
    neurons_in_box = container.box_contents{row, col};
    
    if numel(neurons_in_box) == container.min_box_dist(row, col),
        % shift locally
        shifted = 0;
        while ~shifted,
            new_pos = [container.box_x_bases(col) + randi(container.x_cwidth) - 1,...
                       container.box_y_bases(row) + randi(container.y_cwidth) - 1];
            other_idxs = neurons_in_box(neurons_in_box ~= neuron_to_shift);
            shifted = ~overlaps(positions, new_pos, other_idxs);
        end
    else
        % shift anywhere
        row_to_go = randi(container.rows);
        col_to_go = randi(container.cols);
        neurons_in_box = container.box_contents{row_to_go, col_to_go};
        
        shifted = 0;
        while ~shifted,
            new_pos = [container.box_x_bases(col_to_go) + randi(container.x_cwidth) - 1,...
                       container.box_y_bases(row_to_go) + randi(container.y_cwidth) - 1];
            other_idxs = neurons_in_box(neurons_in_box ~= neuron_to_shift);
            shifted = ~overlaps(positions, new_pos, other_idxs);
        end
    end
end