function [] = resize_images(path, scale)
% Inputs
% 1. path - str - path to folder with images
% 2. scale - float - scale to resize images
%% Resize images to expected sizes
files = dir(path);
resized_folder = join([path, '\', 'resized']);
% Check if directory already exist
if ~exist(resized_folder, 'dir')
    mkdir(resized_folder)
end
% Resize all images in given folder
for i=1:length(files)
    if ~(strcmp(files(i).name, '.') || strcmp(files(i).name, '..'))
        filename = join([files(i).folder, '\', files(i).name]);
        filename_resized = join([resized_folder, '\', files(i).name]);
        img = imread(filename);
        img_resized = imresize(img, scale);
        imwrite(img_resized, filename_resized);
    end    
end
end

