function [valid, inv_idx] = validate_bboxes(input_size, dataset)
% Check if bounding boxes are valid
% Inputs:
% 1. input_size - array - size of image
% 2. dataset - str - dataset path
%% Load dataset and initialize flag
dataset = load(dataset);
dataset = dataset.all_data;
valid = 1;
inv_idx = zeros(1, height(dataset));
%% Perform check
for i=1:height(dataset)
    sitting = dataset.sitting{i};
    standing = dataset.standing{i};
    turned = dataset.turned{i};
    raising_hand = dataset.raising_hand{i};
    [wid, len] = size(sitting); 
    if ~isempty(sitting)
        for j=1:wid
            if (sitting(j,1)+sitting(j,3)) > input_size(1) ||  (sitting(j,2)+sitting(j,4)) > input_size(2)
                fprintf('Found invalid bbox at index %d \n', i);
                valid = 0;
                inv_idx(i) = 1;
            end
        end
    end
    
    [wid, len] = size(standing); 
    if ~isempty(standing)
        for j=1:wid
            if (standing(j,1)+standing(j,3)) > input_size(1) ||  (standing(j,2)+standing(j,4)) > input_size(2)
                fprintf('Found invalid bbox at index %d \n', i);
                valid = 0;
                inv_idx(i) = 1;
            end
        end
    end
    
    [wid, len] = size(turned);
    if ~isempty(turned)
        for j=1:wid
            if (turned(j,1)+turned(j,3)) > input_size(1) ||  (turned(j,2)+turned(j,4)) > input_size(2)
                fprintf('Found invalid bbox at index %d \n', i);
                valid = 0;
                inv_idx(i) = 1;
            end
        end
    end
    [wid, len] = size(raising_hand);
    if ~isempty(raising_hand)
        for j=1:wid
            if (raising_hand(j,1)+raising_hand(j,3)) > input_size(1) ||  (raising_hand(j,2)+raising_hand(j,4)) > input_size(2)
                fprintf('Found invalid bbox at index %d \n', i);
                valid = 0;
                inv_idx(i) = 1;
            end
        end
    end

end

