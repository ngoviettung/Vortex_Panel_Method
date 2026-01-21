function V = velocitySegment(P, A, B)
% T?nh v?n t?c do 1 ?o?n vortex AB t?i ?i?m P
r1 = P - A; 
r2 = P - B; 
r0 = B - A; 

cross_r = cross(r1, r2);
norm_cross = norm(cross_r)^2;

% Tr?nh chia cho 0
if norm_cross < 1e-12
    V = [0 0 0];
    return;
end

V = cross_r/norm_cross * dot(r0, r1/norm(r1) - r2/norm(r2)) / (4*pi);
end
