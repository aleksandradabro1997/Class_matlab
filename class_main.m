% Training a Faster R-CNN deep learning object detector
%% Load training data
data = load('fasterRCNNVehicleTrainingData.mat');
trainingData = data.vehicleTrainingData;
trainingData.imageFilename = fullfile(toolboxdir('vision'), 'visiondata', ...
    trainingData.imageFilename);

%% Shuffle data
rng(0) % set random seed
shuffledIdx = randperm(height(trainingData));
trainingData = trainingData(shuffledIdx,:);
%% Create image and box label datastore and put them together
imds = imageDatastore(trainingData.imageFilename);
blds = boxLabelDatastore(trainingData(:,2));

ds = combine(imds, blds);
%% Set network layers
lgraph = layerGraph(data.detector.Network);

%% Configure training options
 options = trainingOptions('sgdm', ...
      'MiniBatchSize', 1, ...
      'InitialLearnRate', 1e-3, ...
      'MaxEpochs', 7, ...
      'VerboseFrequency', 200, ...
      'CheckpointPath', tempdir);
  
%% Train detector
 detector = trainFasterRCNNObjectDetector(trainingData, lgraph, options, ...
        'NegativeOverlapRange',[0 0.3], ...
        'PositiveOverlapRange',[0.6 1]);
%%
