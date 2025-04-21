function [ flag ] = overlaps( positions, test_pos, others )
%OVERLAPS Check if test_pos overlaps with any of the others.
% Assumption : all neurons are placed on a lattice. Therefore this reduces
% to checking if the lattice point which we are trying to assign to
% test_pos is already occupied by some other neuron.
    flag = 0;
    for i = 1:numel(others),
        if test_pos == positions(others(i), :),
            flag = others(i);
        end
    end
end

