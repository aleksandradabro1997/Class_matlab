function [] = save_video_as_frames(video_path, folder)
% save_video_as_frames - save video as frames
% Inputs:
% 1. video_path - str - path to file with video
% 2. folder - str - path to save images

%% Read video
video = VideoReader(video_path);
%% Get number of frames
nb_of_frames = video.NumFrames;

%% Divide video into frames and save them in given folder
for i = 1: nb_of_frames
    frame = read(video, i);
    if ~exist(sprintf('%04d.jpg', i), 'file')
        imwrite(frame, fullfile(folder, sprintf('%04d.jpg', i)));
    end
end
end

