function [nb_of_anchor_boxes] = select_best_nb_of_anchors(max_num_anchors,training_data)
% select_best_nb_of_anchors - selects best number of anchor boxes according
% to mean intersection over union
% Inputs:
%1. max_num_anchors
%2. training_data
   %% Select best number of anchor boxes

    mean_IoU = zeros([max_num_anchors,1]);
    anchor_boxes = cell(max_num_anchors, 1);
    for k = 1:max_num_anchors
        % Estimate anchors and mean IoU.
        [anchor_boxes{k}, mean_IoU(k)] = estimateAnchorBoxes(training_data,k);    
    end

    figure
    plot(1:max_num_anchors, mean_IoU, '-o');
    grid on;
    ylabel("Mean IoU");
    xlabel("Number of Anchors");
    title("Number of Anchors vs. Mean IoU");
    % IoU - intersection over unit
    [~, idx] = max(mean_IoU);
    nb_of_anchor_boxes = idx;

end

