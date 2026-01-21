function [controlPoints, normals] = computeControlPoints(F, V)
% COMPUTECONTROLPOINTS Tinh control point (collocation) + normal cho tam giac
% F: Mx3, V: Nx3
% controlPoints: Mx3, normals: Mx3

numTriangles = size(F,1);
controlPoints = zeros(numTriangles,3);
normals = zeros(numTriangles,3);

for i = 1:numTriangles
    tri = V(F(i,:), :);
    % normal vector
    n = cross(tri(2,:) - tri(1,:), tri(3,:) - tri(1,:));
    n = n / norm(n);
    normals(i,:) = n;
    
    % centroid
    C = mean(tri,1);
    
    % control point: centroid dich ra ngoai panel
    panelSize = mean([norm(tri(2,:)-tri(1,:)), norm(tri(3,:)-tri(2,:)), norm(tri(1,:)-tri(3,:))]);
    epsilon = 0.01 * panelSize; % % khoang dich ~1% panel
    controlPoints(i,:) = C + epsilon * n;
end
end
