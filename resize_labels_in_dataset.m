function [data] = resize_labels_in_dataset(data, scale)
% Inputs
% 1. data - table - table of data
% 2. scale - float - scale for resizing
% Outputs
% 1. data - table - resized labels
%% Scale labels
for i=1:height(data)
    data.sitting{i} = floor(data.sitting{i}*scale);
    data.standing{i} = floor(data.standing{i}*scale);
    data.raising_hand{i} = floor(data.raising_hand{i}*scale);
    data.turned{i} = floor(data.turned{i}*scale);
end
end

