function createNACA4WingSTL(nacaCode, Nx, Ny, span, filename)
% CREATENACA4WINGSTL
% Tao canh NACA 4-so va xuat STL ASCII
%
% nacaCode : chuoi, vd '2412'
% Nx       : so diem chordwise (vd 20-50)
% Ny       : so diem theo span (vd 10-30)
% span     : canh 2*span (tinh tu centerline)
% filename : ten file STL output, vd 'wing.stl'

m = str2double(nacaCode(1))/100;  % max camber
p = str2double(nacaCode(2))/10;   % vi tri camber
t = str2double(nacaCode(3:4))/100; % do day

c = 1;  % chieu dai chord = 1 m
x = linspace(0,c,Nx)';

% Hang hinh dang canh NACA4
yt = 5*t*(0.2969*sqrt(x/c) - 0.1260*(x/c) - 0.3516*(x/c).^2 + 0.2843*(x/c).^3 - 0.1015*(x/c).^4);

yc = zeros(size(x));
dyc_dx = zeros(size(x));
for i=1:Nx
    if x(i)/c < p
        yc(i) = m/(p^2)*(2*p*(x(i)/c) - (x(i)/c)^2);
        dyc_dx(i) = 2*m/(p^2)*(p - x(i)/c);
    else
        yc(i) = m/((1-p)^2)*( (1-2*p) + 2*p*(x(i)/c) - (x(i)/c).^2 );
        dyc_dx(i) = 2*m/((1-p)^2)*(p - x(i)/c);
    end
end

theta = atan(dyc_dx);

xu = x - yt.*sin(theta);  yu = yc + yt.*cos(theta);
xl = x + yt.*sin(theta);  yl = yc - yt.*cos(theta);

% tao luoi theo span
y_span = linspace(-span, span, Ny);

% tao vertices
vertices = [];
for i = 1:Nx
    for j = 1:Ny
        vertices(end+1,:) = [xu(i), y_span(j), yu(i)]; % upper
    end
end
for i = 1:Nx
    for j = 1:Ny
        vertices(end+1,:) = [xl(i), y_span(j), yl(i)]; % lower
    end
end

% tao faces
faces = [];
for i = 1:Nx-1
    for j = 1:Ny-1
        % upper
        n1 = (i-1)*Ny + j;
        n2 = n1 + 1;
        n3 = n1 + Ny;
        n4 = n3 + 1;
        faces(end+1,:) = [n1 n2 n4];
        faces(end+1,:) = [n1 n4 n3];
        
        % lower
        n1l = Nx*Ny + (i-1)*Ny + j;
        n2l = n1l + 1;
        n3l = n1l + Ny;
        n4l = n3l + 1;
        faces(end+1,:) = [n1l n2l n4l];
        faces(end+1,:) = [n1l n4l n3l];
    end
end

% xuat STL ASCII
writeSTL_ASCII(filename, faces, vertices);

disp(['Da tao STL cho canh ', nacaCode, ' vao file ', filename]);
disp(['Mesh: ', num2str(size(faces,1)), ' tam giac, ', num2str(size(vertices,1)), ' vertices']);
end
