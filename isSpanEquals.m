function [output] = isSpanEquals(S, T)
%ISSPANEQUALS Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    S
    T
end

arguments (Output)
    output
end

    output = isSpanSubset(S, T) & isSpanSubset(T, S)
end
