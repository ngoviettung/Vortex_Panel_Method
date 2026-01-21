function [x_upper,z_upper,Cp_upper,x_lower,z_lower,Cp_lower] = getMidspanCutProfile3D_2016b(V,F,controlPoints,Cp,y_mid)
% C?t midspan profile t? STL 3D, ph?n t?ch Upper/Lower, n?i suy Cp
% MATLAB 2016b compatible

segments = [];

% --- 1. T?o t?t c? segment c?t ---
for i = 1:size(F,1)
    verts = V(F(i,:),:);
    yv = verts(:,2);
    if all(yv < y_mid) || all(yv > y_mid), continue; end
    
    edges = [1 2; 2 3; 3 1];
    pts = [];
    for e = 1:3
        A = verts(edges(e,1),:); B = verts(edges(e,2),:);
        if (A(2)-y_mid)*(B(2)-y_mid) <= 0
            if B(2) ~= A(2)
                t = (y_mid - A(2)) / (B(2)-A(2));
                pt = A + t*(B-A);
                pts = [pts; pt];
            end
        end
    end
    if size(pts,1) >= 2
        segments = [segments; pts(1,:) pts(2,:)];
    end
end

if isempty(segments)
    error('Kh?ng t?m th?y contour midspan');
end

% --- 2. Node duy nh?t v? adjacency graph ---
pts_all = [segments(:,1:3); segments(:,4:6)];
[unique_pts, ~, ic] = unique(round(pts_all*1e8)/1e8,'rows');
edges_graph = reshape(ic,[],2);
G = graph(edges_graph(:,1), edges_graph(:,2));

% --- 3. Traverse t? LE (min x) ?? t?o contour ---
[~, idx_le] = min(unique_pts(:,1));
path = dfsearch(G, idx_le, 'edgetonew');
contour = unique_pts(path,:);

% --- 4. Upper / Lower theo chord ---
[~, idx_te] = max(contour(:,1));
LE = contour(idx_le,:);
TE = contour(idx_te,:);
chord_vec = TE - LE; chord_vec(2)=0;

tmp = [contour(:,1)-LE(1), zeros(size(contour,1),1), contour(:,3)-LE(3)];
cross_prod = cross(repmat(chord_vec,size(contour,1),1), tmp);
upper_idx = cross_prod(:,2) > 0;
lower_idx = ~upper_idx;

x_upper = contour(upper_idx,1); z_upper = contour(upper_idx,3);
x_lower = contour(lower_idx,1); z_lower = contour(lower_idx,3);

% --- 5. S?p x?p LE->TE ---
[x_upper, si] = sort(x_upper); z_upper = z_upper(si);
[x_lower, si] = sort(x_lower,'descend'); z_lower = z_lower(si);

% --- 6. N?i suy Cp nearest neighbor ---
Cp_upper = zeros(size(x_upper));
Cp_lower = zeros(size(x_lower));

for i = 1:length(x_upper)
    d = sum((controlPoints - [x_upper(i) y_mid z_upper(i)]).^2,2);
    [~, idx] = min(d); Cp_upper(i) = Cp(idx);
end

for i = 1:length(x_lower)
    d = sum((controlPoints - [x_lower(i) y_mid z_lower(i)]).^2,2);
    [~, idx] = min(d); Cp_lower(i) = Cp(idx);
end

end
