function [data] = resize_labels_in_dataset(data, scale)
% Scale labels
for i=1:height(data)
    data.sitting{i} = data.sitting{i}*scale;
    data.standing{i} = data.standing{i}*scale;
    data.raising_hand{i} = data.raising_hand{i}*scale;
    data.turned{i} = data.turned{i}*scale;
end
end

