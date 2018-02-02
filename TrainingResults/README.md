trainSqueezenet(percentageTraining,ValidationFrequency,WeightLearnRateFactor,BiasLearnRateFactor,MiniBatchSize,MaxEpochs,InitialLearnRate,LearnRateDropFactor,LearnRateDropPeriod)

+180131-1158: Basic training. 70/30 Validation/Training.
|	      Initial learn rate 1e-4, slowly decreased. Batch size 15. Learn rates for conv10 20.
|	      trainSqueezenet(0.7,3,20,20,15,8,1e-4,0.8,2)
|
+-+180201-1333: Modified Validation/Training to 85/15. Reached 40% but went down to 35 before stopping at epoch 4
  |		trainSqueezenet(0.85,6,20,20,15,8,1e-4,0.8,2)
  |
  +-+180201-1415: Modified batch size to 30. Better performance and behaviour. Still hard to go below loss of 2
    |		  trainSqueezenet(0.85,6,20,20,30,8,1e-4,0.8,2)
    |			
    +-+180201-2026: Modified initial learning rate to 1.156e-4 = 1e-4/(0.8)^2. 
    | |		    Faster behaviour but stops improving once loss reaches 2 in validation
    | |		    trainSqueezenet(0.85,6,20,20,30,8,1.156e-4,0.8,2)
    | |
    | +-+180201-2122: Modified batch size to 50. First time loss go clearly below 2 and accuracy over 50%.
    | | 	      However, still gets stucked.
    | |		      trainSqueezenet(0.85,6,20,20,50,8,1.156e-4,0.8,2)
    | |
    | +-+Modify batch size:45
    | |
    | |
    | +-+Modify batch size 40
    |
    +-+Propose: Modify learning rate
    |
    |
    +-+Propose: Modify weightLearnRateFactor
    