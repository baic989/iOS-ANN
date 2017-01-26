//
//  NeuralNetwork.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit
import Foundation

enum PositionInNetwork {
    case input
    case hidden
    case output
}

class NeuralNetwork {
    
    //MARK: - Properties -
    private var layers:[Layer] = []
    
    // Network topology is an array of integers which represents the structure
    // of the network i.e. [2, 3, 2] creates a network of 3 layers. 2 input neurons
    // 3 hidden neurons and 2 output neurons
    private let networkTopology: [Int]
    
    //MARK: - Lifecycle -
    init(topology: [Int]){
        
        networkTopology = topology
        initNetwork()
    }
    
    // trebam topology u mainu ce se za svaki row zvati trains sa row, network ne treba referencu na to
    
    //MARK: - Helpers -
    private func initNetwork() {
        
        let inputLayerSize = networkTopology.first
        let outputLayerSize = networkTopology.last
        // TODO: Un-hack this
        let hiddenLayerSize = networkTopology[1]
        
        // Init input layer
        if let inputLayerSize = inputLayerSize {
            let inputLayer = Layer(numberOfNeurons: inputLayerSize, position: .input)
            layers.append(inputLayer)
        } else {
            // TODO: tell VC what happened
            #if DEBUG
                print("\nERROR: Unable to init input layer!\n")
            #endif
        }
        
        // Init hidden layer
        // TODO: Fix if more than one hidden layer
        let hiddenLayer = Layer(numberOfNeurons: networkTopology[1], position: .hidden)
        layers.append(hiddenLayer)
        
        if let outputLayerSize = outputLayerSize {
            let outputLayer = Layer(numberOfNeurons: outputLayerSize, position: .output)
            layers.append(outputLayer)
        } else {
            #if DEBUG
                print("\nERROR: Unable to init output layer!\n")
            #endif
        }
        
        initWeightsAndBias()
    }
    
    private func loadDataIntoInputLayer(data: [Double]) {
        
        if let inputLayer = layers.first {
            
            for (neuron, dataValue) in Zip2(inputLayer.neurons, data) {
                neuron.value = dataValue
            }
        } else {
            // TODO: Tell VC what happened
            
            #if DEBUG
            print("\nERROR: Unable to load data into input layer!\n")
            #endif
        }
    }
    
    private func initWeightsAndBias() {
        for i in 1..<layers.count {
            
            let currentLayer = layers[i]
            
            // Each neuron in the current layer will have as many weights
            // as there are neurons in the previous layer
            let feedLayer = layers[i - 1]
            
            for j in 0..<currentLayer.neurons.count {
                let currentNeuron = currentLayer.neurons[j]
                
                for k in 0..<feedLayer.neurons.count {
                    currentNeuron.weights.append(randomWeight())
                }
                
                currentNeuron.bias = randomWeight()
            }
        }
    }
    
    private func randomWeight() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
    
    func trainNetwork(inputData: [[Double]], outputData: [[Int]], numberOfEpochs: Int, learningRate: Double) {
        
        for index in 0..<numberOfEpochs {
            
            for (dataRow, expectedData) in Zip2(inputData, outputData) {
                
                loadDataIntoInputLayer(dataRow)
                forwardPropagete(dataRow)
                backwardPropagate(expectedData)
            }
        }
    }
    
    private func forwardPropagete(inputData: [Double]) {
        
        var inputs = inputData
        
        for layer in layers {
            
            if layer.position != .input {
                var neuronOutput = [Double]()
                
                print("INPUTS: \(inputs) \n")
                for neuron in layer.neurons {
                    neuron.activate(inputs)
                    neuronOutput.append(neuron.value)
                }
                
                inputs = neuronOutput
            }
        }
    }
    
    private func backwardPropagate(expectedData: [Int]) {
        
        // Reverse the layers order so that we start with output layer
        // and move backwards
        for layer in layers.reverse() {
            if layer.position == .output {
                for (neuron, expectedValue) in Zip2(layer.neurons, expectedData) {
                    neuron.calculateError(Double(expectedValue))
                }
            } else {
                // dohvati prijeasnji layer
                // 
            }
        }
    }
}








