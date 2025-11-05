function [U, S, V] = svdExact(A)
%SVDEXACT Exact SVD of A, such that U*S*V == A. Use sym(A) to get exact
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

    % compute singular values until 0 (singular values always >= 0)
    % Note: sqrt() will return (sqrt(D_{i,j})) where D_{i,j} are entries 
    % in D
    S = diag(sqrt(eigenvalues));
    n_S = size(S, 1);
    [m, n] = size(A);
    % pad by adding extra m-n zero rows (or n-m zero cols)
    if m > n
        for i = 1:m-n
            S(n_S+i, :) = zeros(1, n_S);
        end
    else
        for i = 1:n-m
            S(:, n_S+i) = zeros(n_S, 1);
        end
    end
    % S has been obtained

    % Gram-Schmidt on P to get V (n x n)
    [V, ~] = qr(sym(P));

    % compute each u_i
    U = sym([]);
    singularvalues = sqrt(eigenvalues);
    for i = 1:size(V, 1)
        v_i = V(:, i);
        sigma_i = singularvalues(i, :);
        U(:, i) = 1/sigma_i * A * v_i;
    end

    % full QR to "pad" with more orthonormal vectors (not in basis)
    [U, ~] = qr(U);

    % return [U, S, V];
end