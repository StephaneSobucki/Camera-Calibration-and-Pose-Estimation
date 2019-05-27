function [R,t] = findExtrinsics(K,homographies,nb_images)
     R = zeros(3,3,nb_images);
     t = zeros(3,1,nb_images);

     for image = 1:nb_images
         KinvH = K\homographies(:,:,image);
         M = [KinvH(:,1), KinvH(:,2), cross(KinvH(:,1), KinvH(:,2))];
         alpha = (det(M))^(1/4);
         r1 = KinvH(:,1)/alpha;
         r2 = KinvH(:,2)/alpha;
         r3 = cross(r1,r2);
         R(:,:,image) = [r1,r2,r3]';
         t(:,:,image) = KinvH(:,3)/alpha;
         if(t(1,:,image) > 0)
             t(:,:,image) = -t(:,:,image);
             R(:,:,image) = -R(:,:,image);
         end
         R(:,:,image) = orthonormalizeR(R(:,:,image));
     end
end

