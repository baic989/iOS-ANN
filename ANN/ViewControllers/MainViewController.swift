//
//  MainViewController.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        createNeuralNetwork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNeuralNetwork(){
        
        // Imaginary data for 2 classes
        let trainingData = [[1.2, 1.1, 4.3, 5.5, 3.2, 7.6, 2.4, 4.2],
                            [10.5, 11.0, 24.1, 10.0, 15.9, 22.8, 31.3, 9.5]]
        
        // Imaginary outputs for 2 classes
        let expectedData = [[1, 0], [0, 1]]
        
        let neuralNetwork = NeuralNetwork(topology: [trainingData[0].count, 3, expectedData.count])
        
        neuralNetwork.trainNetwork(trainingData, outputData: expectedData, numberOfEpochs: 2, learningRate: 0.1)
        
        // Uncomment to print initial weights and biases
        // Note that input layer's neuron's weights and bias are default
//        for layer in neuralNetwork.layers {
//            
//            for neuron in layer.neurons {
//                print("WEIGHTS: \(neuron.weights) \n")
//                print("BIAS: \(neuron.bias) \n\n")
//            }
//        }
    }
    
    
    @IBAction func feedSampleDataButtonPressed(sender: UIButton) {
    }
    
    @IBAction func trainNetworkButtonPressed(sender: UIButton) {
    }
    
    @IBAction func testNetworkButtonPressed(sender: UIButton) {
    }
}
