function writeSTL_ASCII(filename, F, V)
% WRITE STL ASCII tu faces F va vertices V
% F: Mx3
% V: Nx3

fid = fopen(filename,'w');
fprintf(fid, 'solid matlab\n');

for i = 1:size(F,1)
    v1 = V(F(i,1),:);
    v2 = V(F(i,2),:);
    v3 = V(F(i,3),:);
    
    % tinh vector phap tuyen
    n = cross(v2-v1, v3-v1);
    n = n/norm(n);
    
    fprintf(fid, '  facet normal %.6f %.6f %.6f\n', n);
    fprintf(fid, '    outer loop\n');
    fprintf(fid, '      vertex %.6f %.6f %.6f\n', v1);
    fprintf(fid, '      vertex %.6f %.6f %.6f\n', v2);
    fprintf(fid, '      vertex %.6f %.6f %.6f\n', v3);
    fprintf(fid, '    endloop\n');
    fprintf(fid, '  endfacet\n');
end

fprintf(fid, 'endsolid matlab\n');
fclose(fid);
disp(['Da xuat STL ASCII vao file ', filename]);
end
