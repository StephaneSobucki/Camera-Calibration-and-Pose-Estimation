function K = findIntrinsics(homographies,nb_images)
    V = zeros(2*nb_images,6);
    for image = 1:nb_images
        V(2*(image-1)+1,:) =  v_ij(homographies(:,:,image),1,2)';
        V(2*(image-1)+2,:) = (v_ij(homographies(:,:,image),1,1) - v_ij(homographies(:,:,image),2,2))';
    end
    [~,~,V_svd]=svd(V);
    b=V_svd(:,end);

    cy = (b(2)*b(3)-b(1)*b(5))/(b(1)*b(4)-b(2)^2);
    lambda = b(6) - (b(3)^2+cy*(b(2)*b(3)-b(1)*b(5)))/b(1);
    fx = sqrt(lambda/b(1));
    fy = sqrt(lambda*b(1)/(b(1)*b(4)-b(2)^2));
    gamma = -b(2)*fx^2*fy/lambda;
    cx = gamma*cy/fy - b(3)*fx^2/lambda;

    K = [fx    gamma cx
         0     fy    cy
         0     0      1];
end

