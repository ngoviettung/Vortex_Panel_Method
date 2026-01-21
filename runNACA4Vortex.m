function runNACA4Vortex(nacaCode, Nx, Ny, span, alpha_list, Vinf, rho)
% RUNNACA4VORTEX - Tinh Cl, Cd ve ve canh NACA4 thay doi goc tan (xoay quanh Y)
% nacaCode   - ma so NACA4, vd '2412'
% Nx, Ny     - so panel chordwise va spanwise
% span       - sai canh
% alpha_list - vector goc tan (do)
% Vinf       - vector van toc [Ux Uy Uz]
% rho        - mat do khong khi

if nargin < 7, rho = 1.225; end

%% --- Tao tep STL ---
filename = ['wing_' nacaCode '.stl'];
createNACA4WingSTL(nacaCode, Nx, Ny, span, filename);
[F, V0] = readSTL_ASCII(filename);

%% --- Khoi tao Figure ---
fig = figure('Name',['NACA ',nacaCode,' AoA Simulation'],'Color','w');
hold on; axis equal; grid on;
xlabel('X'); ylabel('Y'); zlabel('Z');
view(30,20);
title(['Wing NACA ', nacaCode, ' - Changing the angle of attack']);
colors = jet(length(alpha_list));

%% --- Bien ket qua ---
Nalpha = length(alpha_list);
Cl_list = zeros(Nalpha,1);
Cd_list = zeros(Nalpha,1);

%Tinh toan cac tham so khi dong, khi goc tan thay doi
for k = 1:Nalpha
    alpha_deg = alpha_list(k);
    alpha = deg2rad(alpha_deg);

    % === Xoa hinh cu ===
    cla; hold on; axis equal; grid on;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    view(30,20);
    title(sprintf('NACA %s - AoA = %.0f degree', nacaCode, alpha_deg));

    % === Xoay quanh truc Y ===
    Ry = [cos(alpha) 0 sin(alpha);
          0          1 0;
         -sin(alpha) 0 cos(alpha)];
    V = (Ry * V0')';

    % === Ve canh ===
    patch('Faces',F,'Vertices',V,'FaceColor',[0.7 0.7 0.9],'EdgeColor','k','FaceAlpha',0.8);
    drawnow;

    % === Sinh panel vortex & tinh toan ===
    [vortexRings, controlPoints, normals] = generateVortexFromSTL_withAoA(filename, alpha_deg, Vinf, 'Y');
    
    Gamma = solveVortexPanel(controlPoints, normals, vortexRings, Vinf);
    
    [Cl, Cd] = computeAerodynamicCoeffs(controlPoints, normals, vortexRings, Gamma, Vinf, rho);

    Cl_list(k) = - Cl;
    Cd_list(k) = Cd;

    % === Hien thi ket qua ===
    text(mean(V(:,1)), mean(V(:,2)), max(V(:,3))*1.1, ...
         sprintf('AoA = %.1f\nCl = %.3f\nCd = %.3f', alpha_deg, Cl, Cd), ...
         'FontSize', 12, 'HorizontalAlignment', 'center');
    drawnow;
    %pause(0.8);
end

%% --- Hien thi ket qua ---
figure('Name','Polar Cl-Cd','Color','w');
subplot(1,2,1);
plot(alpha_list, Cl_list, '-o','LineWidth',2);
xlabel('\alpha (deg)'); ylabel('C_L');
grid on; title(['C_L vs \alpha - NACA ', nacaCode]);

subplot(1,2,2);
plot(Cd_list, Cl_list, '-o','LineWidth',2);
xlabel('C_D'); ylabel('C_L');
grid on; title(['Polar C_L-C_D - NACA ', nacaCode]);

end
