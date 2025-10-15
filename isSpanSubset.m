% check if a span(S) subset span(T)
function [output] = isSpanSubset(S, T)
arguments (Input)
    S
    T
end

arguments (Output)
    output
end
    A = [T S];
    nbFromRight = size(S, 2); % Number of columns in T
    cols = colsNotInSpan(A, nbFromRight);
    % all col vectors in S are in span(T) -> all consistent
    % -> span(S) subset span(T) -> empty cols arr
    output = isempty(cols);
end

