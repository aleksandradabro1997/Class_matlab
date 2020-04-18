% Training a Faster R-CNN deep learning object detector
%% Clear
clear all; close all; clc
%% Create dataset
dataset_name = 'dataset_input224x224x3';
%create_dataset({'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\seria1',...
%                 'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\seria2'}, ...
%                 {'labels_series1.mat', 'labels_series2.mat'}, ...
%                 [224 224 3], [720 1280 3], 'dataset_input224x224x3')

%% Load dataset - previously created
dataset = load(dataset_name);
% Take dataset out of the structure
dataset = dataset.all_data;
% Resize labels to fit them to images
%dataset = resize_labels_in_dataset(dataset, 0.1);
%% Divide dataset into test and training
rng(0); % set random seed
shuffled_indices = randperm(height(dataset));
% Training - 70%, Test - 30%
idx = floor(0.7 * height(dataset)); 

training_idx = 1:idx;
training_data = dataset(shuffled_indices(training_idx), :);
 
validation_idx = idx+1 : idx + 1 + floor(0.1 * length(shuffled_indices) );
validation_data = dataset(shuffled_indices(validation_idx),:);

test_idx = validation_idx(end)+1 : length(shuffled_indices);
test_data = dataset(shuffled_indices(test_idx),:);

%% Create image and box label datastore and put them together
imds = imageDatastore(training_data.filepaths);
imds_test = imageDatastore(test_data.filepaths);

blds_train = boxLabelDatastore(training_data(:,2:5));
blds_test = boxLabelDatastore(test_data(:,2:5));
%% Combine datastores
ds_train = combine(imds, blds_train);
ds_test = combine(imds_test, blds_test);

%% Set training and test data
training_data = ds_train;
test_data = ds_test;

%% Data augmentation
augmented_training_data = transform(training_data, @data_augmentation);
training_data = augmented_training_data;
%% Data augmentation - show results
augmented_data = cell(5,1);
for k = 1:5
data = read(augmented_training_data);
augmented_data{k} = insertShape(data{1}, 'Rectangle', data{2});
reset(augmented_training_data);
end
figure
montage(augmented_data,'BorderSize',5)
%% Select best number of anchor boxes
max_num_anchors = 15;
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
%% Create Faster R-CNN Detection Network
input_size = [72 128 3];
%input_size = [224 224 3];
[max_mean_iou, idx] = max(mean_IoU);
num_anchors = idx;
anchor_boxes = estimateAnchorBoxes(training_data, num_anchors);
feature_extraction_network = resnet50;
feature_layer = 'activation_40_relu';
num_classes = 4;
lgraph = fasterRCNNLayers(input_size, num_classes, anchor_boxes,...
                          feature_extraction_network, feature_layer);
%% Configure training options
 options = trainingOptions('sgdm', ...
      'MiniBatchSize', 4, ...
      'InitialLearnRate', 0.002, ...
      'MaxEpochs', 6, ...
      'VerboseFrequency', 100, ...
      'CheckpointPath', 'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\projekt\Class_matlab');
%% Train or load detector - all classes
train_flag = 0;
if train_flag == 0
    [detector, training_info] = trainFasterRCNNObjectDetector(training_data,...
                                             lgraph, options, ...
                                             'NegativeOverlapRange',[0 0.3], ...
                                             'PositiveOverlapRange',[0.6 1]);
% NegativeOverlapRange - overlap ratio for negative samples
%Negative training samples are set equal to the samples that overlap with
%the ground truth boxes by 0 to 0.3.
% PositiveOverlapRange - overlap ratio for positive samples
%Positive training samples are set equal to the samples that overlap with
%the ground truth boxes by 0.6 to 1.0, measured by the bounding box IoU metric.
else
    detector=load('detector_0_4.mat');
    detector=detector.detector;
end

%% Evaluate detector
detection_results = detect(detector, test_data);

[average, recall, precision] = evaluateDetectionPrecision(detection_results, test_data);
% recall - ability of the detector to find all relevant objects
%% Plot evaluation results
labels = {'sitting'; 'standing'; 'raising_hand'; 'turned'};
for i=1:4
    figure; grid on;
    plot(recall{i}, precision{i}, 'r-o');
    xlabel('Recall');
    ylabel('Precision');
    title(sprintf('Average Precision - %s = %.2f', cell2mat(labels(i)), average(i)));
end
%% Save detector
save('detector_0_7_input224x224x3.mat', 'detector')
%% Test detector
% path = 'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\seria1\resized224x224x3';
% files = dir(path);
% for i=1:length(files)
%     if ~(strcmp(files(i).name, '.') || strcmp(files(i).name, '..'))
%         filename = join([files(i).folder, '\', files(i).name]);
%         img = imread(filename);
%         [bbox, score, label] = detect(detector, img);
% 
%         detected_img = insertObjectAnnotation(img, 'Rectangle', bbox, label, ...
%                                       'TextBoxOpacity', 0.2, 'FontSize', 8);
%         imshow(detected_img);
%     end    
% end
