function [data] = resize_labels_in_dataset_by_input_size(data, current_size, target_size)
% Inputs
% 1. data - table - table of data
% 2. current_size - array - array of current sizes
% 3. target_size - array - sie required
% Outputs
% 1. data - table - resized labels
%% Scale labels
scale = target_size(1:2)./current_size(1:2);

for i=1:height(data)
    if ~isstruct(data.sitting{i})
        data.sitting{i} = bboxresize(floor(data.sitting{i}), scale);
        data.standing{i} = bboxresize(floor(data.standing{i}), scale);
        data.raising_hand{i} = bboxresize(floor(data.raising_hand{i}), scale);
        data.turned{i} = bboxresize(floor(data.turned{i}), scale);
    else
        fprintf('Struct in dataset - idx: %d\n', i);
        data.sitting{i} = [];
        data.standing{i} = [];
        data.raising_hand{i} = [];
        data.turned{i} = [];
    end
end
end
