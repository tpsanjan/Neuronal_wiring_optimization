function [ tdash ] = temp_update( T )
%TEMP_UPDATE Cooling for simulated annealing.
%   At least 2 choices :
%       - exponential decay
%       - linear decay
    delta = 1.1;
    tdash = T / delta;
end

