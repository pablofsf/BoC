%% This is a program to test the accuracy of different CNN
%unzip('MerchData.zip');
images = imageDatastore('Dataset_Clean','IncludeSubfolders',true,'LabelSource','foldernames');
images.ReadFcn = @(loc)imresize(imread(loc),[224,224]);
%[trainingImages,validationImages] = splitEachLabel(images,0.85,'randomized');
trainingImages = images;
validationImages = imageDatastore('ric y esposa','IncludeSubfolders',true,'LabelSource','foldernames');
validationImages.ReadFcn = @(loc)imresize(imread(loc),[224,224]);

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
    'MiniBatchSize',32,...
    'Momentum',0.9,... % default is 0.9
    'MaxEpochs',24,...
    'InitialLearnRate',5e-4,...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropFactor',0.8,...
    'LearnRateDropPeriod',1,... 
    'L2Regularization',0.01,...    
    'VerboseFrequency',5,...
    'ValidationData',validationImages,...
    'ValidationFrequency',20,...
    'Shuffle','every-epoch',...
    'ExecutionEnvironment','auto',... % 'parallel' for multiple CPU cores (the available ones)-- need the Parallel Computing Toolbox installed and dose not work for DAG networks
    'Plots','training-progress',...
    'OutputFcn',@(info)stopIfAccuracyNotImproving(info,12));

netgoogle = trainNetwork(trainingImages,googlegraph,options);

predictedLabels = classify(netgoogle,validationImages);