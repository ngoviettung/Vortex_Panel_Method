function V = velocityVortexRing(P, ringPoints)
% P: ?i?m control point
% ringPoints: 5x3, 4 ?i?m + quay l?i ?i?m ??u
V = [0 0 0];
for k=1:4
    A = ringPoints(k,:);
    B = ringPoints(k+1,:);
    V = V + velocitySegment(P, A, B);
end
end
