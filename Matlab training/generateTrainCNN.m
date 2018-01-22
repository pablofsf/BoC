%% This is a program to test the accuracy of different CNN
%unzip('MerchData.zip');
images = imageDatastore('cnntrainingdata','IncludeSubfolders',true,'LabelSource','foldernames');
images.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
[trainingImages,validationImages] = splitEachLabel(images,0.7,'randomized');

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
    convolution2dLayer(1,numClasses,'Name','conv10_5out','WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    reluLayer('Name','relu_conv10_5out')
    averagePooling2dLayer(13,'Name','avrPool10')
    softmaxLayer('Name','last_softmax')
    classificationLayer('Name','ClassLayer')];

squeezenetGraph = addLayers(squeezenetGraph,newLayers);

squeezenetGraph = connectLayers(squeezenetGraph,'drop9','conv10_5out');

plot(squeezenetGraph);
%%
options = trainingOptions('sgdm',...
    'MiniBatchSize',15,...
    'MaxEpochs',8,...
    'InitialLearnRate',1e-4,...
    'VerboseFrequency',1,...
    'ValidationData',validationImages,...
    'ValidationFrequency',3,...
    'Plots','training-progress');

TrainedNet = trainNetwork(trainingImages,squeezenetGraph,options);

predictedLabels = classify(TrainedNet,validationImages);
accuracy = mean(predictedLabels == validationImages.Labels)
