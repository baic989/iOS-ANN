//
//  MainViewController.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
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
        
        //neuralNetwork.trainNetwork(trainingData, outputData: expectedData, numberOfEpochs: 20, learningRate: 0.5)
        //neuralNetwork.feed([[1, 1, 1, 1], [0, 0, 0, 1]])
        
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let drawViewController = storyboard.instantiateViewControllerWithIdentifier("DrawViewController") as DrawViewController
        let drawViewPresenter = TrainCharacterPresenter(viewController: drawViewController)
        drawViewController.presenter = drawViewPresenter
        
        presentViewController(drawViewController, animated: true, completion: nil)
    }
    
    @IBAction func trainNetworkButtonPressed(sender: UIButton) {
    }
    
    @IBAction func testNetworkButtonPressed(sender: UIButton) {
    }
}
