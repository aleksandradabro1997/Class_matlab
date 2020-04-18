function [data] = resize_labels_in_dataset_by_input_size(data, current_size, target_size)
% Scale labels
scale = target_size(1:2)./current_size(1:2);

for i=1:height(data)
    if ~isstruct(data.sitting{i})
        data.sitting{i} = bboxresize(ceil(data.sitting{i}), scale);
        data.standing{i} = bboxresize(ceil(data.standing{i}), scale);
        data.raising_hand{i} = bboxresize(ceil(data.raising_hand{i}), scale);
        data.turned{i} = bboxresize(ceil(data.turned{i}), scale);
    end
end
end
