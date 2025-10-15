function [] = symrref(A)
% A must be a symbolic matrix
arguments
    A (:, :) {mustBeMatrix}
end
    r = 1;
    c = 1;

    [m, n] = size(A);

    while r <= m && c <= n
        pivot = A(r, c);
        swap = -1;
        isunknown = ~isempty(symvar(pivot));
        is_undesirable_pivot = (pivot == 0 || isunknown);

        if is_undesirable_pivot
            for i = r+1:m
                if A(i, c) ~= 0
                    swap = i;
                    break;
                end
            end
        end

        
        if swap == -1
            if pivot == 0
                c = c + 1;
                continue;
            end
        else
            A([r, swap], :) = A([swap, r], :);
        end

        leading = A(r, c);
        % check our pivot is an unknown
        if ~isempty(symvar(sym(leading)))
            unknowns = symvar(A);

            % solve for each unknown e.g. a*b==1 => a == 1/b or b == 1/a
            for i = 1:length(unknowns)
                disp("[debug solve0] solve(" + string(leading == 0) + ", " + string(unknowns(i)) + ")");
                rhs = solve(leading == 0, unknowns(i));
                if isempty(rhs)  % no solution - continue
                    continue
                end

                % can have many solutions, e.g. b^2 == 4
                for j = 1:length(rhs)
                    disp("When [" + string(unknowns(i) == rhs(j)) + "]");
                    B = subs(A, unknowns(i), rhs(j));
                    symrref(B);
                    disp("Else (" + string(unknowns(i) ~= rhs(j)) + "):");
                end
            end
        end

        % leading not 0, make our leading term 1
        A(r, :) = simplify((1 / leading) * A(r, :));

        % make the other terms in the column 0
        for i = 1:m
            if i == r
                continue
            end

            % Ri - cRj
            curr_leading = A(i, c);
            A(i, :) = simplify(A(i, :) - curr_leading * A(r, :));
            % matlab may give * instead of 0 due to rounding errors
            % we know it must be 0, so we can set to 0 manually
            % A(i, c) = 0;
        end

        r = r + 1;
        c = c + 1;
    end

    disp(A);
end

% function [str] = matrix_to_string(A)
%     [m, n] = size(A);
% 
%     for i = 1:m
%         fprintf("[ ");
%         for j = 1:n
%             fprintf("%d ", A(i, j));
%         end
%         fprintf("]");
%     end
% end
