//
//  NeuralNetwork.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit
import Foundation

struct NeuralNetwork {
    
    //MARK: - Properties -
    let layers:[Layer]!
    let inputData:[[Double]]!
    
    // Network topology is an array of integer which represents the structure
    // of the network i.e. [2, 3, 2] creates a network of 3 layers. 2 input neurons
    // 3 hidden neurons and 2 output neurons
    let networkTopology: [Int]
    
    //MARK: - Lifecycle -
    init(topology: [Int]){
        
        networkTopology = topology
        
        // TODO: Debug conversion error
        //layers = initNetwork(topology: networkTopology)
    }
    
    //MARK: - Helpers -
    func initNetwork() -> [Layer]{
        
        let numberOfLayers = networkTopology.count
        let inputLayerSize = networkTopology.first
        let outputLayerSize = networkTopology.last
        // TODO: Un-hack this
        let hiddenLayerSize = networkTopology[1]

        let hiddenLayer = Layer
        
        // Dummy
        return [Layer]()
    }
    
    func sigmoid(input: Double) -> Double {
        return 1 / (1 + pow(M_E, -input))
    }
    
    func sigmoidDerivative(output: Double) -> Double {
        return output * (1.0 - output)
    }
    
    func trainNetwork(inputData: [[Double]]) {
        
    }
    
    private func forwardPropagete() {

    }
    
    private func backwardPropagate() {
        
    }
}
