trainSqueezenet(
	percentageTraining,
	ValidationFrequency,
	WeightLearnRateFactor,
	BiasLearnRateFactor,
	MiniBatchSize,
	MaxEpochs,
	InitialLearnRate,
	LearnRateDropFactor,
	LearnRateDropPeriod,
	Momentum,//Not present in the first trainings
	L2Regularization)//Not present in the first trainings

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
    | +-+180201-2122,180202-1737,180202-1846,180202-1956: trainSqueezenet(0.85,6,20,20,50,8,1.156e-4,0.8,2)
    | |           Modified batch size to 50. First time loss go clearly below 2 and accuracy over 50%.
    | | 	      However, still gets stucked.
    | |		      Tried several different to understand differences between having different sets.
    | |           Concluded that the set has some influence. Will modify the script and export the images
    | | 
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
    |
    |
    |
    +-+-+180203-1330: Add momentum factor = 0.5
      |               trainSqueezenet(0.85,6,20,20,30,8,1e-4,0.8,2)  (--> momentum not added here in the arguments)
      |   	          Training finished because process reached final iteration (8). 
      |	   	          Validation loss got below 2 (1.88); Mini-batch loss = 1.25
      |	 	            Validation Final Accuracy = 44.2% (peak 46.1%); Mini-batch (training) Final Accuracy = 73.3% (peak 90.0%)
      |	
      +--+-+180203-1459: Change momentum factor to 0.9 
         | |            Increase number of epochs to 16.		        
      	 | |            trainSqueezenet(0.85,6,20,20,30,16,1e-4,0.8,2)  (--> momentum not added here in the arguments)
      	 | |            Traning finished at epoch 15. 
      	 | |	          Validation loss = 1.3 (minimum 1.2); Mini-batch loss = 0.04
         | |     	      Validation Final Accuracy = 67.3% (peak 69.2%); Mini-batch (training) Final Accuracy = 100.0%
         | |       
         | +--+180205-0735: change LearnRateDropFactor to 1.0 (no drop)
         |                  trainSqueezenet(0.85,6,20,20,30,16,1e-4,1,2)
         |                  Validation loss = 1.47 (minimum 1.35); Mini-batch loss = 0.01
         |                  Validation Final Accuracy = 63.5% (peak 69.2%); Mini-batch (training) Final Accuracy = 100.0%
         |         
         +--+180203-1726: Change momentum factor to 0.95 / Epochs = 14
            |              trainSqueezenet(0.85,6,20,20,30,14,1e-4,0.8,2)  (--> momentum not added here in the arguments)
            |              Validation loss = 1.69 (minimum 1.62); Mini-batch loss = 0.09
            |              Validation Final Accuracy = 59.6% (peak 65.4%); Mini-batch (training) Final Accuracy = 96.7% (peak 100%)
            |
            +--+180203-1926: Change momentum factor to 0.85 / Epochs = 14
               |              trainSqueezenet(0.85,6,20,20,30,14,1e-4,0.8,2)  (--> momentum not added here in the arguments) 
               |              Validation loss = 1.05 (minimum 1.05); Mini-batch loss = 0.11 (minimum 0.09)
               |              Validation Final Accuracy = 73.1% (peak 73.1%); Mini-batch (training) Final Accuracy = 96.7% (peak 100%)
               |	
               +--+180204-1755: Change batch size to 50 / change LearnRateDropFactor to 0.9
               |                 trainSqueezenet(0.85,6,20,20,50,16,1e-4,0.9,2) 
               |                 Validation loss = 1.22 (minimum 1.22); Mini-batch loss = 0.18 (minimum 0.13)
               |                 Validation Final Accuracy = 65.4% (peak 65.4%); Mini-batch (training) Final Accuracy = 98.0% (peak 100%)
               |
			   +--+180209-1035: Included momentum to 0.9 / More images and batch size to 64
			      |				trainSqueezenet(0.85,6,20,20,64,16,1.156e-4,0.8,4,0.9);
			      |				Validation loss minimum 1.20; Mini-batch loss = 0.39
			      |				Validation Final Accuracy = 60.77%
			      |
			      +--+180209-1229: Increased InitialLearnRate to 3-e4. Clearly faster and better
				  |	 |   			trainSqueezenet(0.85,6,20,20,64,16,3e-4,0.8,4,0.9);
				  |	 |	    		Validation loss minimum 1.09; Mini-batch loss minimum = 0.18
				  |	 |		    	Validation maximum accuracy = 70.72%
				  |	 |
				  |  +--+180209-1715: Added L2Regularization: 0.1. A bit less irregular
				  |  |					trainSqueezenet(0.85,6,20,20,64,16,3e-4,0.8,4,0.9,0.1);
				  |  |					Validation loss minimum 1.20; Mini-batch loss minimum = 0.16
				  |  |					Validation maximum accuracy = 65%
				  |  |
				  |  +--+180209-1924: Modified L2Regularization to 1. Too high. Useless
				  |  |					trainSqueezenet(0.85,6,20,20,64,16,3e-4,0.8,4,0.9,1);
				  |  |
				  |  +--+180209-2021: Modified L2Regularization to 0.01. 
				  |  					trainSqueezenet(0.85,6,20,20,64,16,3e-4,0.8,4,0.9,0.01);
				  |						Validation loss minimum 1.23; Mini-batch loss minimum
				  |  					Validation maximum accuracy = 63%; Regular accuracy reached 100%
				  |  
				  +--+180209-1414: Increased momentum to 0.95. Similar behaviour around 60% but a bit less irregular
								   trainSqueezenet(0.85,6,20,20,64,16,1.156e-4,0.8,4,0.95);
		
		+--+180211-1307: trainSqueezenet(0.85,6,20,20,64,16,6e-4,0.85,2,0.9,n/a);
				 Validation loss minimum 1.29; Mini-batch loss minimum = 0.06	
				 Validation Final Accuracy = 69.8% (peak 72%); Mini-batch (training) Final Accuracy = 100%
