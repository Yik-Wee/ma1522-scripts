function [] = symrref(A, show_rowops, indent_spaces)
arguments
    A (:, :) {mustBeMatrix}
    show_rowops logical = true
    indent_spaces (1, 1) = 4
end
    if class(A) ~= "sym"
        error("Matrix must be symbolic. try using `sym` instead");
    end

    if size(A, 1) == 0 && size(A, 2) == 0
        disp(A);
        return
    end

    symrref_helper(A, 1, 1, show_rowops, 0, indent_spaces, [])
end

function [] = symrref_helper(A, r, c, show_rowops, indent_level, indent_spaces, conditions)
% A must be a symbolic matrix
arguments
    A (:, :) {mustBeMatrix}
    r (1, 1)
    c (1, 1)
    show_rowops logical = true
    indent_level (1, 1) = 0
    indent_spaces (1, 1) = 4
    conditions(1,:) = []
end
    [m, n] = size(A);

    while r <= m && c <= n
        pivot = A(r, c);
        swap = -1;
        isunknown = ~isempty(symvar(pivot));
        is_undesirable_pivot = (pivot == 0 || isunknown);

        if is_undesirable_pivot
            % find next non-zero pivot
            for i = r+1:m
                if A(i, c) ~= 0
                    swap = i;
                    break;
                end
            end
        end

        
        if swap == -1
            % pivot is 0 and no other non-zero pivots found
            if pivot == 0
                c = c + 1;
                continue;
            end
        else
            % swap to a non-zero pivot
            A([r, swap], :) = A([swap, r], :);
            if show_rowops
                print_indents(indent_level * indent_spaces);
                fprintf("=> R_%d <-> R_%d\n", r, swap);
            end
        end

        leading = A(r, c);

        if has_symvars(leading)
            unknowns = symvar(A);

            % solve for each unknown e.g. a*b==1 => a == 1/b or b == 1/a
            % Note in this example a and b cannot be 0
            for i = 1:length(unknowns)
                rhs = solve(leading == 0, unknowns(i));
                if isempty(rhs)  % no solution - continue
                    continue
                end

                % can have many solutions, e.g. b^2 - 4 == 0
                % then sub (b == 2) then (b == -2)
                for j = 1:length(rhs)
                    print_indents(indent_level * indent_spaces);
                    curr_condition = string(unknowns(i) == rhs(j));
                    disp("When [" + curr_condition + "]");

                    B = subs(A, unknowns(i), rhs(j));
                    symrref_helper(B, ...
                        r, ...
                        c, ...
                        show_rowops, ...
                        indent_level+1, ...
                        indent_spaces, ...
                        [conditions, curr_condition]);

                    % now expr != 0 (since we have recursively solved the
                    % case when expr == 0)
                    curr_condition = string(unknowns(i) ~= rhs(j));
                    % Note: not optimal, but not many conditions so ok
                    conditions = [conditions, curr_condition];
                    print_indents(indent_level * indent_spaces);
                    disp("Else (" + curr_condition + "):");
                end
            end

            indent_level = indent_level + 1;
        end

        % leading not 0, continue with normal gaussian elimination
        % make our leading term 1 (when our leading term is 1 we don't
        % need to divide our row by 1, it does nothing)
        if leading ~= 1
            if show_rowops
                print_indents(indent_level * indent_spaces);
                fprintf("=> (%s)*R_%d\n", string(1 / leading), r);
            end
            A(r, :) = simplify((1 / leading) * A(r, :));
        end

        % make the other terms in the column 0
        for i = 1:m
            if i == r
                continue
            end

            curr_leading = A(i, c);
            % no need compute since Ri - 0*Rj does nothing
            if curr_leading == 0
                continue
            end
            A(i, :) = simplify(A(i, :) - curr_leading * A(r, :));
            % matlab may give * instead of 0 due to rounding errors
            % we know A(i, c) now must be 0, so we can set to 0 manually
            % A(i, c) = 0;

            if show_rowops
                print_indents(indent_level * indent_spaces);
                fprintf("=> R_%d - %s*R_%d\n", i, string(curr_leading), r);
            end
        end

        r = r + 1;
        c = c + 1;
    end

    % how do you properly print a matrix with indentation in matlab ????
    disp(A);
    if isempty(conditions)
        disp("^^^ (no conditions)");
    else
        disp("^^^ " + join(conditions, " AND "));
    end
    disp("====");
end

function [output] = has_symvars(expr)
    output = ~isempty(symvar(sym(expr)));
end

function [indents] = indent_string(n_spaces)
    indents = repmat(" ", 1, n_spaces);
end

function [] = print_indents(n_spaces)
    fprintf("%s", indent_string(n_spaces));
end
