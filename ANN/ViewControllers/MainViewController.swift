//
//  MainViewController.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions -
    @IBAction func feedSampleDataButtonPressed(sender: UIButton) {
        
        let drawViewController = initDrawViewController()
        let drawViewPresenter = TrainCharacterPresenter(viewController: drawViewController)
        drawViewController.presenter = drawViewPresenter
        
        presentViewController(drawViewController, animated: true, completion: nil)
    }
    
    @IBAction func trainNetworkButtonPressed(sender: UIButton) {
        // Load data from userdefaults
        // train network
        
        let pixelsArray = loadCharacterPixelsArray()
        let outputsArray = loadCharacterOutputArray()
        
        createNeuralNetwork(pixelsArray, outputData: outputsArray)
    }
    
    @IBAction func testNetworkButtonPressed(sender: UIButton) {
        
        let drawViewController = initDrawViewController()
        let drawViewPresenter = ClassifyCharacterPresenter(viewController: drawViewController)
        drawViewController.presenter = drawViewPresenter
        
        presentViewController(drawViewController, animated: true, completion: nil)
    }
    
    // MARK: - Neural network -
    func createNeuralNetwork(inputData: [[Int]], outputData: [[Int]]){
        
        let neuralNetwork = NeuralNetwork(topology: [inputData[0].count, 600, outputData[0].count])
        
        neuralNetwork.trainNetwork(inputData, outputData: outputData, numberOfEpochs: 1000, learningRate: 0.5)
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
    
    // MARK: - Navigation -
    private func initDrawViewController() -> DrawViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let drawViewController = storyboard.instantiateViewControllerWithIdentifier("DrawViewController") as DrawViewController
        
        return drawViewController
    }
    
    // MARK: - Setup -
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Helpers -
    // TODO: Refactor constants
    func loadCharacterPixelsArray() -> [[Int]] {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let characterPixelsArray = userDefaults.arrayForKey("characterPixelsArrayKey") as [[Int]]
        
        return characterPixelsArray
    }
    
    func loadCharacterOutputArray() -> [[Int]] {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let characterOutputsArray = userDefaults.arrayForKey("characterOuputArrayKey") as [[Int]]
        return characterOutputsArray
    }
}
