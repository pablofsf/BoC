function net = importSqueezenetCaffe()
    protofile = 'squeezenet_v11.prototxt';
    datafile = 'squeezenet_v11.caffemodel';
    net = importCaffeNetwork(protofile,datafile);
end