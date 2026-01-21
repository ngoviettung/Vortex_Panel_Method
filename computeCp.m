function Cp = computeCp(controlPoints, vortexRings, Gamma, Vinf, normals)
% computeCp - Tinh he so ap suat Cp cho panel vortex-ring 3D
%
% Inputs:
%   controlPoints : Nx3  - Toa do diem dieu khien cua moi panel
%   vortexRings   : cell Nx1 - Moi phan tu la 4 diem dinh [4x3] cua vong xoay
%   Gamma         : Nx1  - Cuong do tuan hoan moi panel
%   Vinf          : 1x3  - Vector van toc tu do [U_x, U_y, U_z]
%   normals       : Nx3  - Vector phap tuyen cua tung panel
%
% Output:
%   Cp            : Nx1  - He so ap suat (Coefficient of Pressure)


N = length(controlPoints);
Cp = zeros(N,1);
VinfMag = norm(Vinf);

% --- Giai han de tranh chia cho 0 ---

if VinfMag < 1e-8
    error('Vinf magnitude is too small.');
end

% --- Vong lap qua tung panel ---
for i = 1:N
    Pi = controlPoints(i,:);
    Vi = Vinf; % % bat dau tu van toc tu do
    
    % --- Cong anh huong cua cac vortex ring ---
    for j = 1:N
        if i ~= j && abs(Gamma(j)) > 1e-12
            Vv = velocityVortexRing(Pi, vortexRings{j});
            Vi = Vi + Gamma(j) * Vv;
        end
    end
    
    % --- Thanh phan phap tuyen ---
    n = normals(i,:) / norm(normals(i,:));
    
    % --- % Loai bo thanh phan phap tuyen (chi can tiep tuyen) ---
    Vt_vec = Vi - dot(Vi, n) * n;
    Vt = norm(Vt_vec);
    
    % --- Cong thuc Cp ---
    Cp(i) = 1 - (Vt / VinfMag)^2;
end

% --- % Xu ly gia tri Cp bat thuong
Cp(~isfinite(Cp)) = 0;  % Loai NaN hoac Inf
Cp = real(Cp);          % loai phan ao (neu co)

end
