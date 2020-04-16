function [resized_folder] = resize_images_by_input_size(path, target_size)
%resize_images_by_input - resize image to target_size

files = dir(path);
resized_folder = join([path, '\', 'resized', num2str(target_size(1)), ...
                       'x', num2str(target_size(2)), ...
                       'x', num2str(target_size(3))]);
                   
% Check if directory already exist
if ~exist(resized_folder, 'dir')
    mkdir(resized_folder)
end
% Resize all images in given folder
for i=1:length(files)
    if ~(files(i).isdir)
        filename = join([files(i).folder, '\', files(i).name]);
        filename_resized = join([resized_folder, '\', files(i).name]);
        img = imread(filename);
        img_size = size(img);
        if target_size(3) ~= img_size(3)
            error('Invalid dimension');
        end
        img_resized = imresize(img, target_size(1:2));
        imwrite(img_resized, filename_resized);
    end    
end
end

