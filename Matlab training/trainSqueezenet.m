% This is a program to test the accuracy of squeezenet

function accuracy = trainSqueezenet(percentageTraining,ValidationFrequency,WeightLearnRateFactor,BiasLearnRateFactor,MiniBatchSize,MaxEpochs,InitialLearnRate,LearnRateDropFactor,LearnRateDropPeriod)
%Import images
ImgSize=227;
images = imageDatastore('TrainingData','IncludeSubfolders',true,'LabelSource','foldernames');
images.ReadFcn = @(loc)imresize(imread(loc),[227 227]);
[trainingImages,validationImages] = splitEachLabel(images,percentageTraining,'randomized');

%Choose here the net. Right now this script is only ready to work with Squeezenet
importedNet = importSqueezenet();


squeezenetGraph = layerGraph(importedNet);
squeezenetGraph = removeLayers(squeezenetGraph, {'conv10','relu_conv10_relu','global_average_pooling2d_1','loss_softmax','ClassificationLayer_loss'});

numClasses = numel(categories(trainingImages.Labels));
%Creation of layers to adapt the net to work with our specific group of
%images
newLayers = [
    convolution2dLayer(1,numClasses,'Name','conv10_5out','WeightLearnRateFactor',WeightLearnRateFactor,'BiasLearnRateFactor',BiasLearnRateFactor)
    reluLayer('Name','relu_conv10_5out')
    averagePooling2dLayer(13,'Name','avrPool10')
    softmaxLayer('Name','last_softmax')
    classificationLayer('Name','ClassLayer')];

squeezenetGraph = addLayers(squeezenetGraph,newLayers);

squeezenetGraph = connectLayers(squeezenetGraph,'drop9','conv10_5out');

%Show that the modification of the layers has been successful
%plot(squeezenetGraph);

options = trainingOptions('sgdm',...
    'MiniBatchSize',MiniBatchSize,...
    'MaxEpochs',MaxEpochs,...
    'InitialLearnRate',InitialLearnRate,...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',LearnRateDropFactor,...
    'LearnRateDropPeriod',LearnRateDropPeriod,...
    'VerboseFrequency',1,...
    'ValidationData',validationImages,...
    'ValidationFrequency',ValidationFrequency,...
    'Shuffle','every-epoch',...
    'Plots','training-progress');

TrainedNet = trainNetwork(trainingImages,squeezenetGraph,options);

predictedLabels = classify(TrainedNet,validationImages);
accuracy = mean(predictedLabels == validationImages.Labels)
end
