function [Cl, Cd] = computeAerodynamicCoeffs(controlPoints, normals, vortexRings, Gamma, Vinf, rho)
% COMPUTEAERODYNAMICCOEFFS
% Tinh Cl, Cd tu phan ap suat Cp tren tung panel (duoc tinh boi computeCp)
% Inputs:
%   controlPoints - Nx3
%   normals       - Nx3 (don vi)
%   vortexRings   - cell array Nx1 (moi cell 5x3)
%   Gamma         - Nx1
%   Vinf          - 1x3
%   rho           - mat do (mac dinh 1.225)
% Outputs:
%   Cl, Cd

if nargin < 6 || isempty(rho)
    rho = 1.225;
end

% tinh Cp tu ham co san (ban da co)
Cp = computeCp(controlPoints, vortexRings, Gamma, Vinf, normals);  % Nx1


N = length(vortexRings);
if length(Cp) ~= N
    error('So Cp khong khop so vortex rings');
end

% tinh dien tich tung panel (ap prox bang tam giac tu 3 diem dau)
A_panel = zeros(N,1);
for i = 1:N
    vr = vortexRings{i};
    p1 = vr(1,:); p2 = vr(2,:); p3 = vr(3,:);
    Ai = 0.5 * norm(cross(p2 - p1, p3 - p1));
    if Ai < 1e-12
        % thu cap khac neu can
        p1 = vr(2,:); p2 = vr(3,:); p3 = vr(4,:);
        Ai = 0.5 * norm(cross(p2 - p1, p3 - p1));
    end
    A_panel(i) = Ai;
end

% qinf
VinfMag = norm(Vinf);
q0 = 0.5 * rho * VinfMag^2;

% tong hop luc tu pressure: Fi = - q0 * Cp_i * n_i * A_i
F_total = [0 0 0];
for i = 1:N
    ni = normals(i,:);
    Fi = - q0 * Cp(i) * ni * A_panel(i);  % 1x3
    F_total = F_total + Fi;
end

% Debug in mot so thong tin de kiem tra
if nargout==0 || true
    % in 1 so thong tin quan trong (co the comment neu khong can)
    fprintf('debug computeAerodynamicCoeffs: sum(Cp*A)=%.6e, mean|n|=%.3f\\n', sum(Cp .* A_panel), mean(sqrt(sum(normals.^2,2))));
    fprintf('F_total = [%.6f %.6f %.6f]\\n', F_total(1), F_total(2), F_total(3));
    % in mot so Cp va normals mau
    nshow = min(6, N);
    fprintf('Cp(1:%d) = ', nshow); fprintf(' %.4e', Cp(1:nshow)); fprintf('\\n');
    fprintf('n(1:%d) =\\n', nshow); disp(normals(1:nshow,:));
end

% chieu luc va keo: lift = tuong ung truc Z, drag theo X
% neu hop tac voi he toa do cua ban: lift = Fz, drag = -Fx (dieu chinh neu can)
Lift = -F_total(3);
Drag = -F_total(1);  % negative because pressure positive on front gives -Fx as drag

% Sref xac dinh tu controlPoints
span = max(controlPoints(:,2)) - min(controlPoints(:,2));
chord = max(controlPoints(:,1)) - min(controlPoints(:,1));
Sref = max(eps, span * chord);

Cl = - Lift / (q0 * Sref);
Cd = Drag / (q0 * Sref);

fprintf('computeAerodynamicCoeffs: Sref=%.6g, Lift=%.6g, Drag=%.6g, Cl=%.6f, Cd=%.6f\\n', Sref, Lift, Drag, Cl, Cd);
end
