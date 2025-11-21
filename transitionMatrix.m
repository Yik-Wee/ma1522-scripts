function [P] = transitionMatrix(from, to)
%TRANSITIONMATRIX get the transition matrix from `from` to `to`
% for this to work, necessarily, V = span(from) = span(to)
% and `from` and `to` must both be bases of V
    len = size(from, 2);
    R = rref([to, from]);
    if (inputname(1))
        disp("[" + inputname(2) + " | " + inputname(1) + "] --> rref");
    end
    disp(R);

    P = R(1:len, len+1:end);
end