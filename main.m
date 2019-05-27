close all;
clear all;
%% Chargement des images
folder = 'chessboard_imgs';
extension = 'jpg';
[image_set,nb_images] = readImages(folder,extension);
%%
[~,boardSize] = detectCheckerboardPoints(image_set(:,:,1));
%% Coordonn�es monde
square_size = 28;%mm
world_points = generateCheckerboardPoints(boardSize, square_size);
%% Estimation des homographies
nb_iterations = 1000;%iterations RANSAC
threshhold = 0.5;%seuil en pixel pour verification des inliers dans RANSAC
[homographies,~,error_tab] = findHomographies(image_set,nb_iterations,threshhold,nb_images);
%% Affichage de l'erreur de reprojection moyenne sur chaque image
figure;
bar(error_tab);
xlabel('Image');
ylabel('Erreur de reprojection moyenne (pixel)');
%% Extraction des param�tres intrinseques
K = findIntrinsics(homographies,nb_images);
%% Extraction des param�tre extrinseques
[R,t] = findExtrinsics(K,homographies,nb_images);
location = zeros(3,1,nb_images);
for i = 1:nb_images
    location(:,:,i) = -t(:,:,i)'*R(:,:,i)';
end
%% Trajectoire
figure;
labels = cell(nb_images,1);
for i = 1:nb_images
    labels{i} = num2str(i);
    plotCamera('location',location(:,:,i),'orientation',R(:,:,i)','size',10,'label',labels{i});
    hold on;
end
plot3(world_points(:,1),world_points(:,2),zeros(length(world_points)),'bo');
plot3(0,0,0,'go');%Origine du rep�re
plot3(location(1,:)',location(2,:)',location(3,:)','black-');
hold off;
xlabel('x(mm)');
ylabel('y(mm)');
zlabel('z(mm)');
grid on;
set(gca,'ZDir','reverse','XDir','reverse');
title('Positions successives de la cam�ra dans le rep�re monde');
