function [] = run_detector_on_pictures(filepath, detector)
% run_detector_on_pictures - run pretrained detector on data
%Inputs:
% 1. filepath - str - path to folder with pictures
% 2. detector - str - detector name
%%
detector=load(detector);
detector=detector.detector;
files = dir(filepath);
for i=1:length(files)
    if ~(strcmp(files(i).name, '.') || strcmp(files(i).name, '..'))
        filename = join([files(i).folder, '\', files(i).name]);
        img = imread(filename);
        [bbox, ~, label] = detect(detector, img);

        detected_img = insertObjectAnnotation(img, 'Rectangle', bbox, label, ...
                                      'TextBoxOpacity', 0.2, 'FontSize', 8);
        imshow(detected_img);
    end    
end
end

