function [p] = projOntoSpan(w, V)
%PROJONTOSPAN calculate the projection of w onto subspace spaned by V (Col(V))
arguments (Input)
    w (:, 1) {mustBeMatrix}
    V (:, :) {mustBeMatrix}
end

arguments (Output)
    p (:, 1)
end
    % find a basis for Col(V)
    [~, Rb] = rref(V);
    basis = V(:, Rb);

    % make the basis orthonormal
    % Theorem: let A be an m x n matrix, whos columns are linearly
    % independent. Then, A = QR
    % [Q, ~] = qr(sym(basis), "econ");  % equivalent
    Q = orth(sym(basis));

    % Theorem: suppose the columns of Q form an orthonormal basis for V,
    % then for any w in R^n, projection of w onto V, p, is given by:
    % p = Q * Q' * w  (Q' is the transpose of Q)
    p = Q * Q' * w;
end