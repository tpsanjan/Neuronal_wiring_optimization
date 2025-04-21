function [ L ] = total_length( positions, adj_mat, fixed_pt_conns )
%TOTAL_LENGTH Find the total wire length of this network
    N = size(positions, 1);
    L = 0;
    for i = 1:N,
        for j = 1:N,
            L = L + adj_mat(i,j) * norm(positions(i,:) - positions(j,:));
        end        
    end
    
    % Add fixed point connections.
    for i = 1:N,
        fps = fixed_pt_conns{i};
        for i_fp = 1:size(fps,1),
            % Add distance to sensors, NMJs etc.
            L = L + norm(double(positions(i,:)) - fps(i_fp,:));
        end
    end
end

