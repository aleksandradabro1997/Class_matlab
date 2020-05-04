function [] = print_augmentation_result(augmented_training_data)
% print_augmentation_result - plot the result of augmentation
% Inputs:
% 1. augmented_training_data - cell - data after augmentation
%%
augmented_data = cell(4,1);
    for k = 1:4
        data = read(augmented_training_data);
        augmented_data{k} = insertShape(data{1}, 'Rectangle', data{2});
        reset(augmented_training_data);
    end
    figure
    montage(augmented_data, 'BorderSize', 5)
end

