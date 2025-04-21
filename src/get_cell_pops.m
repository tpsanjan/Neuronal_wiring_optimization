function [ pops ] = get_cell_pops( positions, filterset, container )
%GET_CELL_POPS Get cell populations for the given set of neurons, specified
%by the filterset.
    pops = zeros(container.box_count);
    filterpos = positions(filterset,:);
    for i = 1:size(filterpos,1),
        pos = filterpos(i,:);
        x_cell = 1 + floor(pos(1) / container.x_cwidth);
        y_cell = 1 + floor(pos(2) / container.y_cwidth);
        pops(y_cell, x_cell) = pops(y_cell, x_cell) + 1;
    end
end

