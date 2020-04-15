function [all_data] = create_dataset(frame_paths, label_paths,  ...
                                     network_input_size, current_size, ...
                                     varargin)
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
%% Initialize arrays
filepaths_all = {};
sitting_all = {};
standing_all = {};
raising_hand_all = {};
turned_all = {};
%% Create table of data
for i =1:length(frame_paths)
    %% Take data out of the cell
    frames_path = cell2mat(frame_paths(:,i));
    labels_path = cell2mat(label_paths(:,i));
    %% Take labels out of the structure
    labels = load(labels_path);
    %% Resize data if necessary
    if ~(isequal(current_size, network_input_size))
        path_to_folder_resized = resize_images_by_input_size(frames_path,...
                                                             network_input_size);
        data = resize_labels_in_dataset_by_input_size(labels.gTruth.LabelData, ...
                                               current_size, network_input_size);      
    end
    %% Create list of file directories
    files = dir(path_to_folder_resized);
    filepaths = cell(height(data),1);
    for j=1:length(files)
        if ~isempty(regexp(files(j).name, 'jpg', 'once')) 
            filepaths(j) = {join([files(j).folder, '\', files(j).name])};
        end
    end
    % Remove empty cells
    filepaths = filepaths(~cellfun('isempty',filepaths));
    filepaths_all = {filepaths_all{:} filepaths{:}};
    %% Take labels out of the structure
    sitting_all = { sitting_all{:} data.sitting{:}};
    standing_all = { standing_all{:} data.standing{:}};
    raising_hand_all = { raising_hand_all{:} data.raising_hand{:}};
    turned_all = { turned_all{:} data.turned{:}};
end
filepaths = filepaths_all';
sitting = sitting_all';
standing = standing_all';
raising_hand = raising_hand_all';
turned = turned_all';
all_data = table(filepaths, sitting, standing, raising_hand, turned);
save(dataset_name, 'all_data');
end

