function [U, S, V] = svdExact(A)
%SVDEXACT Exact SVD of A, such that U*S*V == A. 
% NOTE: Use sym(A) to get exact
arguments (Input)
    A (:, :)
end

arguments (Output)
    U
    S
    V
end
    B = A'*A;
    % B = A'*A is symmetric <==> orthogonally diagonalizable
    % P and D will both be sq matrices of same size
    % Note: using symbolic matrix may break as symbolic roots of char(B)
    %       may be unable to be simplified to a real number, and instead
    %       expressed as a symbolic complex number. This will break the
    %       later step when sorting the eigenvalues, since 
    [P, D] = eig(B);

    % rearrange column vectors in P while sorting through eigenvalues desc
    % order (bubblesort good enough for small matrices)
    eigenvalues = diag(D);
    len = length(eigenvalues);
    for i = 1:len
        swapped = 0;

        for j = 1:len-i
            if eigenvalues(j, :) < eigenvalues(j+1, :)
                % swap eigenvalues
                eigenvalues([j, j+1], :) = eigenvalues([j+1, j], :);
                % D(:, [j, j+1]) = D(:, [j+1, j]);
                % swap cols of P accordingly
                P(:, [j, j+1]) = P(:, [j+1, j]);
                swapped = 1;
            end
        end

        if swapped == 0
            break;
        end
    end

    % remove zeros from eigenvalues
    eigenvalues = eigenvalues(eigenvalues ~= 0);
    % we can guarantee that r <= n
    r = length(eigenvalues);

    % compute singular values until 0 (singular values always >= 0)
    % Note: sqrt() will return (sqrt(D_{i,j})) where D_{i,j} are entries 
    % in D
    S = diag(sqrt(eigenvalues));  % r x r matrix
    [m, n] = size(A);

    % edge case: all singular values are 0
    if r == 0
        S = sym(zeros(m, n));
    else
        if r < n
            S(:, r+1:n) = zeros(r, n-r);
        end
        % we now have n columns

        if r < m
            S(r+1:m, :) = zeros(m-r, n);
        end
        % we now have m columns
    end

    % Gram-Schmidt on P to get V (n x n)
    [V, ~] = qr(sym(P));

    % compute each u_i
    U = sym([]);
    singularvalues = sqrt(eigenvalues);
    for i = 1:r
        v_i = V(:, i);
        sigma_i = singularvalues(i, :);
        if sigma_i ~= 0
            u_i = 1/sigma_i * A * v_i;
            U(:, i) = u_i;
        end
    end

    % edge case: all eigenvalues are 0 -> U 0x0
    % make U the standard basis for R^m
    if r == 0
        U = sym(eye(m));
    end

    % full QR to "pad" with more orthonormal vectors (not in basis)
    [U, ~] = qr(U);

    % simplify in case not already simplified
    U = simplify(U);
    % S = simplify(S);
    V = simplify(V);
end