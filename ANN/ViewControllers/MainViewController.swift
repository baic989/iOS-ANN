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
        let trainingData = [[0, 1, 1, 0],
                            [0, 0, 0, 0],
                            [1, 0, 1, 0],
                            [1, 0, 0, 1],
                            [0, 1, 0, 1]]
        
        // Imaginary outputs for 2 classes
        let expectedData = [[1, 0], [0, 1], [1, 0], [1, 0], [1, 0]]
        
        let neuralNetwork = NeuralNetwork(topology: [trainingData[0].count, 3, expectedData[0].count])
        
        neuralNetwork.trainNetwork(trainingData, outputData: expectedData, numberOfEpochs: 200, learningRate: 0.5)
        
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
