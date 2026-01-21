function Gamma = solveVortexPanel(controlPoints, normals, vortexRings, Vinf)
% SOLVEVORTEXPANEL_WITHKUTTA
% Tinh cuong do xoay Gamma, ap dung dieu kien Kutta o trailing edge
%
% Inputs:
%   controlPoints - Nx3, diem dieu khien panel
%   normals       - Nx3, vector phap tuyen panel
%   vortexRings   - cell Nx1, moi phan tu 4 diem
%   Vinf          - 1x3, van toc tu do
%
% Output:
%   Gamma         - Nx1, cuong do tuan hoan panel

N = length(vortexRings);
A = zeros(N);
b = zeros(N,1);

% --- Xac dinh trailing edge (TE)
flow_dir = Vinf / norm(Vinf);
proj = controlPoints * flow_dir';
proj_max = max(proj);
tol = 1e-6*(proj_max - min(proj));
te_idx = find(abs(proj - proj_max) < tol);

% Phan upper/lower TE
te_points = controlPoints(te_idx,:);
z_mean = mean(te_points(:,3));
upper_idx = te_idx(te_points(:,3) > z_mean);
lower_idx = te_idx(te_points(:,3) <= z_mean);

% --- Tao ma tran A va vector b
disp('Tao ma tran anh huong...');
for i = 1:N
    Pi = controlPoints(i,:);
    ni = normals(i,:);
    for j = 1:N
        A(i,j) = ni * velocityVortexRing(Pi, vortexRings{j})';
    end
    b(i) = -ni * Vinf';
end

% --- Them dieu kien Kutta: Gamma_upper + Gamma_lower = 0
if ~isempty(upper_idx) && ~isempty(lower_idx)
    kutta_row = zeros(1,N);
    kutta_row(upper_idx) = 1/length(upper_idx);
    kutta_row(lower_idx) = 1/length(lower_idx);
    A = [A; kutta_row];
    b = [b; 0];
end

% --- Giai he
Gamma = pinv(A) * b;

disp('Hoan tat tinh Gamma voi Kutta!');
disp(['So vortex rings: ', num2str(length(Gamma))]);
disp(['Gamma min: ', num2str(min(Gamma)), ', max: ', num2str(max(Gamma))]);

end
