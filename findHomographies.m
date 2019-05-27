function [homographies,image_points_estimate_mat,error_tab] = findHomographies(image_set,nb_iter,threshhold,nb_images)
    [~,boardSize] = detectCheckerboardPoints(image_set(:,:,1));
    %% Coordonn�es monde
    square_size = 28;%mm
    world_points = generateCheckerboardPoints(boardSize, square_size);
    homographies = zeros(3,3,nb_images);
    image_points_estimate_mat = zeros(size(world_points,1),3,nb_images);
    error_tab = zeros(nb_images,1);
    for image = 1:nb_images

        image_points = detectCheckerboardPoints(image_set(:,:,image));

        homogeneous_world_points = [world_points ones(size(world_points,1),1)];
        homogeneous_image_points = [image_points ones(size(image_points,1),1)];

        old_inliers = 0;
        best_error_std = Inf;

        % RANSAC
        for k = 1:nb_iter
            rand_index = randperm(size(homogeneous_image_points,1),4);
            image_points_random_sample = zeros(4,3);
            world_points_random_sample = zeros(4,3);

            for i = 1:4
                image_points_random_sample(i,:) = homogeneous_image_points(rand_index(i),:);
                world_points_random_sample(i,:) = homogeneous_world_points(rand_index(i),:);
            end

            H = DLT(world_points_random_sample,image_points_random_sample);

            image_points_estimate = (H*homogeneous_world_points')';

            image_points_estimate = image_points_estimate./image_points_estimate(:,3);

            error = sqrt((image_points_estimate(:,1)-homogeneous_image_points(:,1)).^2+...
                (image_points_estimate(:,2)-homogeneous_image_points(:,2)).^2);
            curr_error_std = std(error);
            inliers = length(find(error < threshhold));

            if(inliers > old_inliers || ((inliers == old_inliers) && (curr_error_std < best_error_std)))
                old_inliers = inliers;
                index_inliers = rand_index;
                best_error_std = curr_error_std;
                if(old_inliers > length(image_points)*95/100)
                    break;
                end
            end
        end

        for i = 1:length(index_inliers)
            image_points_random_sample(i,:) = homogeneous_image_points(index_inliers(i),:);
            world_points_random_sample(i,:) = homogeneous_world_points(index_inliers(i),:);
        end

        H = DLT(world_points_random_sample,image_points_random_sample);

        image_points_estimate = (H*homogeneous_world_points')';
        image_points_estimate = image_points_estimate ./ image_points_estimate(:,3);
        image_points_estimate_mat(:,:,image) = image_points_estimate;

        error_tab(image) = mean(sqrt((image_points_estimate(:,1)-homogeneous_image_points(:,1)).^2+...
            (image_points_estimate(:,2)-homogeneous_image_points(:,2)).^2));

        homographies(:,:,image) = H;
    end
end

