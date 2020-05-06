function [detector_name,detector_info] = determine_detector_name(training_options)
% determine_detector_name - generate name for detector based on training
% options
% Inputs:
% 1. training_options - str - path to mat file with training options
% Outputs:
% 1. detector_name - str - generated detector name
% 2. detector_info - str - name of struct of training info
%%
load(training_options);
detector_name = ['detector', '_', 'solver', '_', solver ,'fen', '_', feature_extraction_network_name, '_',...
                 'fl', '_', feature_layer, '_', 'mbs', mat2str(mini_batch_size), '_', ...
                 'lr', '_', mat2str(learn_rate), '_', 'me', mat2str(max_epochs), '_', ...
                 'no', mat2str(negative_overlap), '_', 'po', '_', mat2str(positive_overlap), ...
                 '_', 'aug', '_', augmentation];
detector_info = [detector_name, 'TI.mat'];
detector_name = [detector_name, '.mat'];
end

