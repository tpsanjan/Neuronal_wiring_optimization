function [ p ] = accept_prob( dL, T )
%ACCEPT_PROB Metropolis-Hastings acceptance probability.
    if dL < 0,
        p = 1;
    else
        p = exp(-dL / T);
    end
end

