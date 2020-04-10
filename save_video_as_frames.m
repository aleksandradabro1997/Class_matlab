function [] = save_video_as_frames(video_path, folder)

video = VideoReader(video_path);
nb_of_frames = video.NumFrames;


for i = 1: nb_of_frames
    frame = read(video, i);
    if ~exist(sprintf('%04d.jpg', i), 'file')
        imwrite(frame, fullfile(folder, sprintf('%04d.jpg', i)));
    end
end
end

