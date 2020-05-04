function [] = define_training_options(save_path,input_size, feature_extraction_network, feature_extraction_network_name,...
                                      feature_layer, mini_batch_size , learn_rate, max_epochs, ...
                                      verbose_freq, checkpoint_path, negative_overlap, positive_overlap, augmentation)
%define_training_options - define training options and save them to mat
% Inputs:
% 1. save_path - path to save mat
% 2. feature_extraction_network -
% 3. feature_layer
% 4. mini_batch_size
% 5. learn_rate
% 6. max_epochs
% 7. verbose_freq
% 8. checkpoint_path
% 9. negative_overlap
% 10. positive_overlap
%%

save(save_path, 'input_size', 'feature_extraction_network', 'feature_extraction_network_name' ,...
     'feature_layer', 'mini_batch_size' , 'learn_rate', 'max_epochs', ...
     'verbose_freq', 'checkpoint_path', 'negative_overlap', 'positive_overlap', 'augmentation')
end

