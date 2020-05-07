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
detector_name = ['detector', 'solver', solver ,'fen', feature_extraction_network_name,...
                 'fl', feature_layer, 'mbs', mat2str(mini_batch_size), ...
                 'lr', mat2str(learn_rate), 'me', mat2str(max_epochs), ...
                 'no', mat2str(negative_overlap), 'po', mat2str(positive_overlap), ...
                 'aug', augmentation];
detector_info = join([detector_name, 'TI.mat'],'_');
detector_name = join([detector_name, '.mat'], '_');
end

