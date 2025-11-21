function [x_inf] = eqvec(P)
%EQVEC return the unique equilibrium vector x_inf of a 
% regular stochastic matrix P
    x = null(eye(size(P)) - P);
    disp("Basis for null(I-P):");
    disp(x);
    % necessarily, dim(E1) = 1, because if not, 
    %   let {v1, v2} be a basis for E1, then
    %   x = s*v1 + t*v2 
    %   so we can find 2 distinct equilibrium vectors
    %   x_inf = v1/sum(v1) or v2/sum(v2)
    %   but x_inf must be unique (<= regular stochastic matrix)
    %   thus a contradiction
    x_inf = x / sum(x);
end