function [average, recall, precision] = evaluate_detector(detector, test_data)
% evaluate_detector - check the accuracy of the detector
% Inputs:
% 1. detector - fasterRCNNObjectDetector - pretrained detector
% 2. test_data - Datastore - test dataset
% Outputs:
% 1. average - array - accuracy of the detector
% 2. recall - array - tp/(tp+fn)
% 3. precision - array - tp/(tp+fp)
%%
detection_results = detect(detector, test_data.UnderlyingDatastores{1});
[average, recall, precision] = evaluateDetectionPrecision(detection_results, test_data.UnderlyingDatastores{2});
end

