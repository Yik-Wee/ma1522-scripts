function [proj_w_onto_u] = proj(w, u)
%PROJ calculates the projection of w onto u
arguments (Input)
    w
    u
end

arguments (Output)
    proj_w_onto_u
end

if u == 0
    proj_w_onto_u = zeros(size(w));
    return;
end

proj_w_onto_u = (dot(w, u) / (norm(u)^2)) * u;
end