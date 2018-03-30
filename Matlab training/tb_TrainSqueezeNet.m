clear all;
%% This is a program to test the accuracy of different CNN
images = imageDatastore('Dataset_Clean','IncludeSubfolders',true,'LabelSource','foldernames');
images.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
%[trainingImages,validationImages] = splitEachLabel(images,0.85,'randomized');
trainingImages = images;
validationImages = imageDatastore('ric y esposa','IncludeSubfolders',true,'LabelSource','foldernames');
validationImages.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
%% Choose here the net
importedNet = importSqueezenet();

%Has to be coherent with layer. Only useful for array net
%layersTransfer = net.Layers(1:end-2);
squeezenetGraph = layerGraph(importedNet);
squeezenetGraph = removeLayers(squeezenetGraph, {'conv10','relu_conv10_relu','global_average_pooling2d_1','loss_softmax','ClassificationLayer_loss'});

numClasses = numel(categories(trainingImages.Labels));
%Has to be adapted to our net
newLayers = [
%    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    convolution2dLayer(1,numClasses,'Name','conv10_5out','WeightLearnRateFactor',100,'BiasLearnRateFactor',100)
    reluLayer('Name','relu_conv10_5out')
    averagePooling2dLayer(13,'Name','avrPool10')
    softmaxLayer('Name','last_softmax')
    classificationLayer('Name','ClassLayer')];

squeezenetGraph = addLayers(squeezenetGraph,newLayers);

squeezenetGraph = connectLayers(squeezenetGraph,'drop9','conv10_5out');

plot(squeezenetGraph);

options = trainingOptions('sgdm',...
    'MiniBatchSize',170,...
    'Momentum',0.9,... % default is 0.9
    'MaxEpochs',24,...
    'InitialLearnRate',1e-4,...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',0.7,...
    'LearnRateDropPeriod',2,... 
    'L2Regularization',0.01,...    
    'VerboseFrequency',5,...
    'ValidationData',validationImages,...
    'ValidationFrequency',20,...
    'Shuffle','every-epoch',...
    'ExecutionEnvironment','auto',... % 'parallel' for multiple CPU cores (the available ones)-- need the Parallel Computing Toolbox installed and dose not work for DAG networks
    'Plots','training-progress',...
    'OutputFcn',@(info)stopIfAccuracyNotImproving(info,12));

TrainedNet = trainNetwork(trainingImages,squeezenetGraph,options);
TrainedNet_wFullABC = TrainedNet;
save TrainedNet_wFullABC;
%%
predictedLabels = classify(TrainedNet,validationImages);
predictedTraining = classify(TrainedNet,validationImages);
predictedValidation = classify(TrainedNet,trainingImages);
accuracy = mean(predictedLabels == validationImages.Labels)
