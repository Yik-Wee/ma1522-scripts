% returns the column numbers that are not in the column space
% The bar is nbFromRight cols from the right
function [output] = colsNotInSpan(A, nbFromRight)
    [rows cols] = size(A);
    R = rref(A);

    output = [];

    for i = 1:rows
        % check if zero row
        if all(R(i, [1:cols-nbFromRight]) == 0)
            % check numbers right of bar are zero
            for j = 1:nbFromRight
                col_j = cols - nbFromRight + j;
                val = R(i,cols-nbFromRight+j);
                if val ~= 0 & ~ismember(col_j, output)
                    output = [output col_j];
                end
            end
        end
    end
end
