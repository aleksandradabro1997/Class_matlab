% Training a Faster R-CNN deep learning object detector
%% Clear
clear all; close all; clc
%% Create dataset
%dataset = create_dataset({'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\seria2'},...
%                         {'D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\labels_series2.mat'});
%% Load dataset - previously created
dataset = load('dataset_all.mat');
% Take dataset out of the structure
dataset = dataset.data3;
% Resize labels to fit them to images
dataset = resize_labels_in_dataset(dataset, 0.1);
%% Divide dataset into test and training
rng(0) % set random seed
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
blds_sitting = boxLabelDatastore(training_data(:,2));
blds_standing = boxLabelDatastore(training_data(:,3));
blds_raising_hand = boxLabelDatastore(training_data(:,4));
blds_turned = boxLabelDatastore(training_data(:,5));

imds_test = imageDatastore(test_data.filepaths);
blds_sitting_test = boxLabelDatastore(test_data(:,2));
blds_standing_test = boxLabelDatastore(test_data(:,3));
blds_raising_hand_test = boxLabelDatastore(test_data(:,4));
blds_turned_test = boxLabelDatastore(test_data(:,5));

blds_train = boxLabelDatastore(training_data(:,2:5));
blds_test = boxLabelDatastore(test_data(:,2:5));

ds_train = combine(imds, blds_train);
ds_test = combine(imds_test, blds_test);
ds_sitting = combine(imds, blds_sitting);
ds_standing = combine(imds, blds_standing);
ds_raising_hand = combine(imds, blds_raising_hand);
ds_turned = combine(imds, blds_turned);
%% Set training and test data
training_data = ds_train;
test_data = ds_test;
%% Select best number of anchor boxes
max_num_anchors = 15;
mean_IoU = zeros([max_num_anchors,1]);
anchor_boxes = cell(max_num_anchors, 1);
for k = 1:max_num_anchors
    % Estimate anchors and mean IoU.
    [anchor_boxes{k},mean_IoU(k)] = estimateAnchorBoxes(training_data,k);    
end

figure
plot(1:max_num_anchors,mean_IoU,'-o');
grid on;
ylabel("Mean IoU");
xlabel("Number of Anchors");
title("Number of Anchors vs. Mean IoU");
%% Create Faster R-CNN Detection Network
input_size = [72 128 3];
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
      'InitialLearnRate', 1e-3, ...
      'MaxEpochs', 1, ...
      'VerboseFrequency', 200, ...
      'CheckpointPath', tempdir);
 % 'Plots','training-progress' <- dla kazdej iteracji wyswietla metryki tylko  CPU??? 
%% Train detector - all classes
 detector = trainFasterRCNNObjectDetector(ds_train, lgraph, options, ...
        'NegativeOverlapRange',[0 0.3], ...
        'PositiveOverlapRange',[0.6 1]);
%% Evaluate detector
detector=load('detector_0_1.mat');
detector=detector.detector;
detection_results = detect(detector, test_data);

[ap, recall, precision] = evaluateDetectionPrecision(detection_results, test_data);
% recall -ability of the detector to find all relevant objects
%%
labels = {'sitting'; 'standing'; 'raising_hand'; 'turned'};
for i=1:4
    figure
    plot(recall{i},precision{i})
    xlabel('Recall')
    ylabel('Precision')
    grid on
    title(sprintf('Average Precision - %s = %.2f', cell2mat(labels(i)), ap(i)))
end
%% Test detector
img = imread('D:\STUDIA\Magisterka\I ROK\I SEMESTR\ICZ\seria1\resized\0500.jpg');
%detector=load('detector_0_1.mat');
detector=detector.detector;
[bbox, score, label] = detect(detector, img);

detected_img = insertShape(img, 'Rectangle', bbox);
figure();
imshow(detected_img);