function [neuron_box_assignments] = initial_neuron_box_assignments(container, N)
% INITIAL_NEURON_BOX_ASSIGNMENTS assign boxes to each neuron.
    % N : num_neurons
    if nargin < 2,
        N = 277; % What we know to be the truth anyway.
    end

    % Return an assignment to a box for each neuron.
    n_placed = 0;
    neuron_idxs = randperm(N);
    neuron_box_assignments = zeros(N,2);
    for row = 1:container.rows,
        for col = 1:container.cols,
            % Put the minimum number of neurons required in each box first.
            num_to_put = container.min_box_dist(row, col);
            neurons_to_put = neuron_idxs(n_placed + 1 : n_placed + num_to_put);
            for neuron = neurons_to_put,
                neuron_box_assignments(neuron,:) = [row, col]; 
            end
            n_placed = n_placed + num_to_put;
        end
    end
    
    % leftover neurons
    for neuron = n_placed + 1 : N,
        idx = neuron_idxs(neuron);
        neuron_box_assignments(idx, :) = [randi(container.rows), randi(container.cols)];
    end    
end