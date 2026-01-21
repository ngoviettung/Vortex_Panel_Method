function [vortexRings, controlPoints, normals] = generateVortexFromSTL_withAoA(filename, alpha_deg, Vinf, axis)
% axis = 'Y' de xoay quanh truc Y
if nargin < 4, axis = 'Y'; end

[F,V0] = readSTL_ASCII(filename);

% Xoay theo goc tan
alpha = deg2rad(alpha_deg);
switch axis
    case 'Y'
        Ry = [ cos(alpha) 0 sin(alpha);
                0        1    0;
              -sin(alpha) 0 cos(alpha)];
        V = (Ry*V0')';
    case 'Z'
        Rz = [cos(alpha) -sin(alpha) 0;
              sin(alpha)  cos(alpha) 0;
              0           0          1];
        V = (Rz*V0')';
end

% Tinh control points + normals
[controlPoints, normals] = computeControlPoints(F, V);

% Chinh huong normals
for i = 1:size(normals,1)
    if dot(normals(i,:), Vinf) < 0
        normals(i,:) = -normals(i,:);
    end
end

% Tao vortex rings 4 diem tu moi tam giac
numTriangles = size(F,1);
vortexRings = cell(0,1);
for i = 1:numTriangles
    tri = V(F(i,:),:);
    if rank(tri-mean(tri,1)) < 2, continue; end
    L = [norm(tri(2,:)-tri(1,:)), norm(tri(3,:)-tri(2,:)), norm(tri(1,:)-tri(3,:))];
    [~, idx] = max(L);
    switch idx
        case 1
            M = (tri(1,:)+tri(2,:))/2;
            vortexRing = [tri(1,:); M; tri(2,:); tri(3,:); tri(1,:)];
        case 2
            M = (tri(2,:)+tri(3,:))/2;
            vortexRing = [tri(1,:); tri(2,:); M; tri(3,:); tri(1,:)];
        case 3
            M = (tri(3,:)+tri(1,:))/2;
            vortexRing = [tri(1,:); tri(2,:); tri(3,:); M; tri(1,:)];
    end
    vortexRings{end+1} = vortexRing;
end
end
