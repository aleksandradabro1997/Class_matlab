function [data] = data_augmentation(data)
% data_augumentation - transforming training data to increase the size of
% Inputs:
% 1. data - Datastore - data to be augmented
% Outputs:
% 1. data - Datastore - data after transformation
%% FLIP BY X AXIS
%tform = randomAffine2d('XReflection', true);
tform = randomAffine2d('YReflection', true);
rout = affineOutputView(size(data{1}),tform);
data{1} = imwarp(data{1},tform,'OutputView',rout);
% bboxwarp expects matrix of int
data{2} = ceil(data{2});
data{2} = bboxwarp(data{2},tform,rout);
end

