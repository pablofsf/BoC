% This is a program to test the accuracy of squeezenet

function accuracy = trainSqueezenet(percentageTraining,ValidationFrequency,WeightLearnRateFactor,BiasLearnRateFactor,MiniBatchSize,MaxEpochs,InitialLearnRate,LearnRateDropFactor,LearnRateDropPeriod)
%Import images
ImgSize=227;
images = imageDatastore('TrainingData','IncludeSubfolders',true,'LabelSource','foldernames');
images.ReadFcn = @(loc)imresize(imread(loc),[ImgSize ImgSize]);
[trainingImages,validationImages] = splitEachLabel(images,percentageTraining,'randomized');

%Import squeezeNet
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

startTime = clock;
TrainedNet = trainNetwork(trainingImages,squeezenetGraph,options);

%Save and close the training plot
trainingPlot = findall(0,'type','figure');
print(trainingPlot,mat2str(startTime(1:5)),'-dpng');
close(trainingPlot);

predictedLabels = classify(TrainedNet,validationImages);
accuracy = mean(predictedLabels == validationImages.Labels)
end
