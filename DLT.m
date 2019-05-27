function [H] = DLT(world_points,image_points)
A = zeros(size(world_points,1)*2,9);
[T1,world_points_normalized] = normalization2d(world_points);
[T2,image_points_normalized] = normalization2d(image_points);

for i = 1:4
    A(2*(i-1)+1,:) = [-world_points_normalized(i,:) zeros(1,3) world_points_normalized(i,:)*image_points_normalized(i,1)];
    A(2*(i-1)+2,:) = [zeros(1,3) -world_points_normalized(i,:) world_points_normalized(i,:)*image_points_normalized(i,2)];
end

[~,~,V] = svd(A);

h = V(:,end);

H = [h(1) h(2) h(3)
     h(4) h(5) h(6)
     h(7) h(8) h(9)];
 
H = T2\H*T1;
end

