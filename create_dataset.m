function [all_data] = create_dataset(frame_paths, label_paths, varargin)
% Create dataset from given data
% Inputs must be cell arrays
if ~isempty(varargin)
    dataset_name = varargin{1};
else
    dataset_name = 'dataset.mat';
end
%% Check if paths for labels and figures are given
if length(frame_paths) ~= length(label_paths)
    error('frame_paths and labels_paths are not the same length')
end
%% Create table of data

for i =1:length(frame_paths)
    %% Take data out of the cell
    frames_path = cell2mat(frame_paths(i,:));
    labels_path = cell2mat(label_paths(i,:));
    %% Take labels out of the structure
    labels = load(labels_path);
    sitting = labels.gTruth.LabelData.sitting;
    standing = labels.gTruth.LabelData.standing;
    raising_hand = labels.gTruth.LabelData.raising_hand;
    turned = labels.gTruth.LabelData.turned;
        
    %% Create list of file directories
    files = dir(frames_path);
    filepaths = cell(length(sitting),1);
    for j=1:length(files)
        if ~isempty(regexp(files(j).name, 'jpg', 'once')) 
            filepaths(j) = {join([files(j).folder, '\', files(j).name])};
        end
    end
    % Remove empty cells
    filepaths = filepaths(~cellfun('isempty',filepaths));
    
end

all_data = table(filepaths, sitting, standing, raising_hand, turned);
save(dataset_name, 'all_data');
end

