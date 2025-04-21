function [ celeg ] = celeg_container_info( min_flag )
%CELEG_CONTAINER_INFO Create box parameters for the container that will
%represent our C. elegans' body.
%   min_flag : whether to have minimum membership constraints on each box
%   cell or not.
%   Components of the struct - celeg:
%   1) box_count: dimensions [2 20]
%   2) min_box_dist: intial distribution (for w/o fix pt data approach)
%   3) rows: no. of rows (=2)
%   4) cols: no. of cols (=20)
%   5) x_range: dimension in microns
%   6) y_range: dimension in microns
%   7) box_x_bases: x coord of start positions of boxes
%   8) box_y_bases: y coord of start positions of boxes
%   9) x_cwidth: dimension of compartment along X axis
%   10)y_cwidth: dimension of compartment along Y axis
%   11)box_contents: neurons indices in the compartments

    celeg = struct;
    
    celeg.box_count = [2 20]; % How many cells in which to divide the container.

    if min_flag == 1,
        % How many neurons should be there at the minimum in each box?
        % Basis : more no. of neurons in posterior end
        min_head = 12;
        celeg.min_box_dist = [min_head * ones(2, 3), ones(2, 17)];
    else
        celeg.min_box_dist = zeros(2,20);
    end

    celeg.rows = celeg.box_count(1);
    celeg.cols = celeg.box_count(2);

    celeg.x_range = [0 1000]; % micron is the unit of length
    celeg.y_range = [0 10];
    
    % Where each cell begins (cell of the container, not a real cell).
    celeg.box_x_bases = floor((0:(1/celeg.cols):1) * (celeg.x_range(2) - celeg.x_range(1))) + celeg.x_range(1);
    celeg.box_x_bases = celeg.box_x_bases(1:end-1);
    celeg.box_y_bases = floor((0:(1/celeg.rows):1) * (celeg.y_range(2) - celeg.y_range(1))) + celeg.y_range(1);
    celeg.box_y_bases = celeg.box_y_bases(1:end-1);
    
    % Cell width in x and y.
    celeg.x_cwidth = (celeg.x_range(2) - celeg.x_range(1)) / celeg.cols;
    celeg.y_cwidth = (celeg.y_range(2) - celeg.y_range(1)) / celeg.rows;

    % List of neurons which are in each cell : empty on init. Will be
    % filled in later.
    for row = 1:celeg.rows,
        for col = 1:celeg.cols,
            celeg.box_contents{row, col} = [];
        end
    end
end