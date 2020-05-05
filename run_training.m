function [test_data, detector] = run_training(dataset_name, train_size, max_num_anchors,training_options)
% run_training - run detector training with configured parameters
% Inputs:
% 1. dataset_name - str - dataset to load
% 2. train_size - double - 0-1 
% 3. training_options - str - path to mat file with training options
% Outputs:
% 1. test_data - datastore - test data
% 2. detector - fasterRCNNObjectDetector - trained detector
%% Determine training parameters
    load(training_options);
    [detector_name, detector_info] = determine_detector_name(training_options);
%% Load dataset - previously created
    dataset = load(dataset_name);
    % Take dataset out of the structure
    dataset = dataset.all_data;
    % Resize labels to fit them to images
    dataset = resize_labels_in_dataset(dataset, 0.1);
    %% Divide dataset into test and training
    [ds_train, ds_test] = train_test_split(dataset, train_size);

    %% Set training and test data
    training_data = ds_train;
    test_data = ds_test;

    %% Data augmentation
    if augmentation
        augmented_training_data = transform(training_data, @data_augmentation);
        training_data = augmented_training_data;
        %% Data augmentation - show results
        print_augmentation_result(training_data);
    end
    %% Select best number of anchor boxes
    num_anchors = select_best_nb_of_anchors(max_num_anchors, training_data);
    anchor_boxes = estimateAnchorBoxes(training_data, num_anchors);
    %% Create Faster R-CNN Detection Network
    num_classes = 4;
    lgraph = fasterRCNNLayers(input_size, num_classes, anchor_boxes,...
                              feature_extraction_network, feature_layer);
    %% Configure training options
     options = trainingOptions('sgdm', ...
          'MiniBatchSize', mini_batch_size, ...
          'InitialLearnRate', learn_rate, ...
          'MaxEpochs', max_epochs, ...
          'VerboseFrequency', verbose_freq, ...
          'CheckpointPath', 'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\projekt\Class_matlab');
    %% Train or load detector - all classes
    [detector, training_info] = trainFasterRCNNObjectDetector(training_data,...
                                                              lgraph, options, ...
                                                              'NegativeOverlapRange',negative_overlap, ...
                                                              'PositiveOverlapRange',positive_overlap);
    %% Save detector and training info
    save(detector_name, 'detector');
    save(detector_info, 'training_info');
end