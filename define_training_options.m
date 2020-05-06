function [] = define_training_options(save_path, solver, input_size, feature_extraction_network, feature_extraction_network_name,...
                                      feature_layer, mini_batch_size , learn_rate, max_epochs, ...
                                      verbose_freq, checkpoint_path, negative_overlap, positive_overlap, augmentation)
%define_training_options - define training options and save them to mat
% Inputs:
% 1. save_path - str - path to save mat
% 2. feature_extraction_network - DAG Network - network desired to feature extraction
% 3. feature_layer - str - layer for feature extraction
% 4. mini_batch_size - int - number of pictures for mini batch
% 5. learn_rate - double - required learning rate
% 6. max_epochs - int - number of training epochs
% 7. verbose_freq - int - info frequency
% 8. checkpoint_path - str - path to save checkpoints
% 9. negative_overlap - array - indicator which bbox overlaps are not
% treated as correct
% 10. positive_overlap - array - indicator which bbox overlaps are
% 11. solver - str - solver name
% treated as correct
%%

save(save_path, 'solver', 'input_size', 'feature_extraction_network', 'feature_extraction_network_name' ,...
     'feature_layer', 'mini_batch_size' , 'learn_rate', 'max_epochs', ...
     'verbose_freq', 'checkpoint_path', 'negative_overlap', 'positive_overlap', 'augmentation')
end

