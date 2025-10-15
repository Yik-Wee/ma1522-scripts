function [p] = projOntoSpan(w, S)
%PROJONTOSPAN calculate the projection of w onto span S (col(S))
arguments (Input)
    w
    S
end

arguments (Output)
    p
end

[rows, cols] = size(S);

p = zeros(rows, 1);

for i = 1:cols
    u = S(:, i);
    p = p + proj(w, u);
end
end