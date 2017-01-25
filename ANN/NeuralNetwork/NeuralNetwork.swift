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
    var layers:[Layer] = []
    
    // Network topology is an array of integers which represents the structure
    // of the network i.e. [2, 3, 2] creates a network of 3 layers. 2 input neurons
    // 3 hidden neurons and 2 output neurons
    let networkTopology: [Int]
    
    //MARK: - Lifecycle -
    init(topology: [Int]){
        
        networkTopology = topology
        initNetwork()
    }
    
    // trebam topology u mainu ce se za svaki row zvati trains sa row, network ne treba referencu na to
    
    //MARK: - Helpers -
    mutating func initNetwork() {
        
        let inputLayerSize = networkTopology.first
        let outputLayerSize = networkTopology.last
        // TODO: Un-hack this
        let hiddenLayerSize = networkTopology[1]
        
        // Init input layer
        if let inputLayerSize = inputLayerSize {
            let inputLayer = Layer(numberOfNeurons: inputLayerSize)
            layers.append(inputLayer)
        } else {
            // tell VC what happened
            #if DEBUG
                print("Unable to init input layer!")
            #endif
        }
        
        // Init hidden layer
        let hiddenLayer = Layer(numberOfNeurons: 2)
        layers.append(hiddenLayer)
        
        if let outputLayerSize = outputLayerSize {
            let outputLayer = Layer(numberOfNeurons: outputLayerSize)
            layers.append(outputLayer)
        } else {
            #if DEBUG
                print("Unable to init output layer!")
            #endif
        }
        
        initWeightsAndBias()
    }
    
    func initWeightsAndBias() {
        
    }
    
    func sigmoid(input: Double) -> Double {
        return 1 / (1 + pow(M_E, -input))
    }
    
    func sigmoidDerivative(output: Double) -> Double {
        return output * (1.0 - output)
    }
    
    func trainNetwork(inputData: [Double]) {
        // forward propagate row
    }
    
    private func forwardPropagete() {

    }
    
    private func backwardPropagate() {
        
    }
}
