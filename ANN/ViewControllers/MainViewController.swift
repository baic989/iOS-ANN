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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNeuralNetwork(){
        
        let trainingData = [[1.2, 1.1, 4.3, 5.5, 3.2, 7.6, 2.4, 4.2],
                            [10.5, 11.0, 24.1, 10.0, 15.9, 22.8, 31.3, 9.5]]
        
        let neuralNetwork = NeuralNetwork(topology: [trainingData.count, 3, 2])
        //neuralNetwork.trainNetwork(trainingData)
    }
    
    
    @IBAction func feedSampleDataButtonPressed(sender: UIButton) {
    }
    
    @IBAction func trainNetworkButtonPressed(sender: UIButton) {
    }
    
    @IBAction func testNetworkButtonPressed(sender: UIButton) {
    }
}
