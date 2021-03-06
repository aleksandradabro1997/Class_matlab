function [ds_train, ds_test, ds_valid] = train_test_split(dataset, train_size)
%train_test_split - divide dataset into test and training datastores
% Inputs:
% 1. dataset - table - whole dataset
% 2. train_size - float - 0-1 size of training dataset
% Outputs:
% 1. ds_train - datastore - training data
% 2. ds_test - datastore - test data
%% Divide dataset into test and training
    rng(0); % set random seed
    shuffled_indices = randperm(height(dataset));
    
    idx = floor(train_size * height(dataset)); 

    training_idx = 1:idx;
    training_data = dataset(shuffled_indices(training_idx), :);

    validation_idx = idx+1 : idx + floor(0.1 * length(shuffled_indices) );
    validation_data = dataset(shuffled_indices(validation_idx),:);

    test_idx = validation_idx(end)+1 : length(shuffled_indices);
    test_data = dataset(shuffled_indices(test_idx),:);

    %% Create image and box label datastore and put them together
    imds = imageDatastore(training_data.filepaths);
    imds_test = imageDatastore(test_data.filepaths);
    imds_valid = imageDatastore(validation_data.filepaths);

    blds_train = boxLabelDatastore(training_data(:,2:5));
    blds_test = boxLabelDatastore(test_data(:,2:5));
    blds_valid = boxLabelDatastore(validation_data(:,2:5));
    %% Combine datastores
    ds_train = combine(imds, blds_train);
    ds_test = combine(imds_test, blds_test);
    ds_valid = combine(imds_valid, blds_valid);
end

