function [adj,indeg_freq,outdeg_freq] = degree_dist()
% DEGREE_DIST Compute degree distribution histograms for the C. elegans
% dataset.
    adj = csvread('./celegansNervousSystemDataset/celeg_adj_mat.csv');
    pos = csvread('./celegansNervousSystemDataset/celeg_positions.csv');
    fx_pts = csvread('./celegansNervousSystemDataset/celeg_fixed_pt_conns.csv');
    
    N = size(adj,1);
    
    in_degrees = zeros(N, 1);
    out_degrees = zeros(N, 1);
    for node = 1:N,
        in_degrees(node) = sum(adj(:,node));        % summing over rows
        out_degrees(node) = sum(adj(node,:));       % summing over columns
    end

    x = pos(:,2);           
    y = pos(:,3);                               % assuming linear

    for node = 1:N,
        if out_degrees(node) == 0,
            color = 'y';
        elseif out_degrees(node) < 10,
            color = 'b';
        else
            color = 'r';
        end

        scatter(x(node), y(node), 30, color, 'filled');
        
        hold on;
    end
    plot(fx_pts(:,2),fx_pts(:,3),'+');
    
    figure;
    for node = 1:N,
        if in_degrees(node) == 0,
            color = 'y';
        elseif in_degrees(node) < 10,
            color = 'b';
        else
            color = 'r';
        end

        scatter(x(node), y(node), 30, color, 'filled');
        hold on;
    end
    plot(fx_pts(:,2),fx_pts(:,3),'+');
    
    figure;
    hist(in_degrees, max(in_degrees) + 1);              % to plot
    indeg_freq = hist(in_degrees, max(in_degrees) + 1); % for power law fit
       

    figure;
    hist(out_degrees, max(out_degrees) + 1);                % to plot
    outdeg_freq = hist(out_degrees, max(out_degrees) + 1);  % for power law fit
end