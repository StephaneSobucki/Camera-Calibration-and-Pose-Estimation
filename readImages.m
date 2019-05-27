function [dataset,numImgs] = readImages(folder,extension)
    Imgs = dir([folder '/' strcat('*.',extension)]);
    numImgs = size(Imgs,1);
    image = rgb2gray(imread([folder '/' Imgs(1).name]));
    dataset = zeros([size(image),numImgs]);
    for i=1:numImgs
        image = rgb2gray(imread([folder '/' Imgs(i).name]));
        dataset(:,:,i) = image;
    end
end
