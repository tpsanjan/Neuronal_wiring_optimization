function pos = initial_positions(box_assgn, container)
% Assign initial positions to each neuron, keeping their assigned boxes in
% mind.
    N = size(box_assgn,1); % Number of neurons.
    pos = zeros(N,2);
    
    box_place_count = zeros(prod(container.box_count), 1);
    for neuron = 1:N,
        row_col = box_assgn(neuron,:); % Which box to put.
        row = row_col(1);
        col = row_col(2);
        boxidx = sub2ind(container.box_count, row, col); % Linearise.
        place_idx = box_place_count(boxidx) + 1;
        
        % Place the neuron.
        row_base = floor((row - 1) * container.y_cwidth); % Cell base.
        col_base = floor((col - 1) * container.x_cwidth);
        row_ind = row_base + mod(place_idx, container.y_cwidth); % Convert index to 2d.
        col_ind = col_base + floor(place_idx / container.y_cwidth);
        pos(neuron,:) = [col_ind, row_ind]; % (x,y)
        box_place_count(boxidx) = box_place_count(boxidx) + 1;
    end
end