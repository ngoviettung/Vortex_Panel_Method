function [F,V] = readSTL_ASCII(filename)
% READSTL_ASCII Doc STL ASCII (tuong thich MATLAB 2016b)
% F: Mx3 array, moi hang la 3 index vertex cua 1 tam giac
% V: Nx3 array, toa do vertices


fid = fopen(filename,'r');
if fid == -1
    error('Khong mo duoc file STL');
end

V = [];
F = [];
vcount = 0;

while ~feof(fid)
    tline = fgetl(fid);
    if contains(tline,'vertex')
        nums = sscanf(tline,' vertex %f %f %f');
        V = [V; nums'];
        vcount = vcount + 1;
        if mod(vcount,3) == 0
            F = [F; vcount-2, vcount-1, vcount];
        end
    end
end

fclose(fid);

% Loai bo diem trung lap
[V, ~, ic] = unique(V,'rows');
F = ic(F);
end
