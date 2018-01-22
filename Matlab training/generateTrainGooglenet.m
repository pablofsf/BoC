%% This is a program to test the accuracy of different CNN
%unzip('MerchData.zip');
images = imageDatastore('cnntrainingdata','IncludeSubfolders',true,'LabelSource','foldernames');
images.ReadFcn = @(loc)imresize(imread(loc),[224,224]);
[trainingImages,validationImages] = splitEachLabel(images,0.7,'randomized');

%% Choose here the net
netgoogle = googlenet;
googlegraph = layerGraph(netgoogle);

googlegraph = removeLayers(googlegraph, {'loss3-classifier','prob','output'});

numClasses = numel(categories(trainingImages.Labels));
newLayers = [
    fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',20,'BiasLearnRateFactor', 20)
    softmaxLayer('Name','softmax')
    classificationLayer('Name','classoutput')];
googlegraph = addLayers(googlegraph,newLayers);

googlegraph = connectLayers(googlegraph,'pool5-drop_7x7_s1','fc');
%%
options = trainingOptions('sgdm',...
    'MiniBatchSize',15,...
    'MaxEpochs',8,...
    'InitialLearnRate',1e-4,...
    'VerboseFrequency',1,...
    'ValidationData',validationImages,...
    'ValidationFrequency',3,...
    'Plots','training-progress');

netgoogle = trainNetwork(trainingImages,googlegraph,options);

predictedLabels = classify(netgoogle,validationImages);
accuracy = mean(predictedLabels == validationImages.Labels)
