function net = importSqueezenet()
    net = importKerasNetwork('squeezenet.json','WeightFile','squeezenet.h5','OutputLayerType','classification');
end