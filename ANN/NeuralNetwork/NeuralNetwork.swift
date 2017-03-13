//
//  NeuralNetwork.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
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
    fileprivate var layers:[Layer] = []
    
    // Network topology is an array of integers which represents the structure
    // of the network i.e. [2, 3, 2] creates a network of 3 layers. 2 input neurons
    // 3 hidden neurons and 2 output neurons
    fileprivate let networkTopology: [Int]
    
    //MARK: - Lifecycle -
    init(topology: [Int]){
        
        networkTopology = topology
        initNetwork()
    }
    
    // MARK: - Public -
    func trainNetwork(_ inputData: [[Int]], outputData: [[Int]], numberOfEpochs: Int, learningRate: Double) {
        
        for index in 0..<numberOfEpochs {
            
            for (inputRow, outputRow) in zip(inputData, outputData) {
                
                loadDataIntoInputLayer(inputRow)
                let result = forwardPropagete(inputRow).map {
                    round($0)
                }
                //print("Expected: \(outputRow)\n Prediction: \(result) \n\n")
                backwardPropagate(outputRow)
                updateWeightsAndBias(inputRow, learningRate: learningRate)
            }
            
            print("Training \((index/numberOfEpochs)*100)% complete\n\n")
        }
    }
    
    func feed(_ inputData: [[Int]]) {
        
        print("REAL DATA\n")
        
        for dataRow in inputData {
            
            let result = forwardPropagete(dataRow).map {
                Int(round($0))
            }
            
            print("Data: \(dataRow) Expected: [1, 0] Prediction: \(result)") // Expectation is hardcoded because we know what we expect
        }
    }
    
    //MARK: - Helpers -
    fileprivate func initNetwork() {
        
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
    
    fileprivate func loadDataIntoInputLayer(_ data: [Int]) {
        
        if let inputLayer = layers.first {
            
            for (neuron, dataValue) in zip(inputLayer.neurons, data) {
                neuron.value = Double(dataValue)
            }
        } else {
            // TODO: Tell VC what happened
            
            #if DEBUG
            print("\nERROR: Unable to load data into input layer!\n")
            #endif
        }
    }
    
    fileprivate func initWeightsAndBias() {
        for i in 1..<layers.count {
            
            let currentLayer = layers[i]
            
            // Each neuron in the current layer will have as many weights
            // as there are neurons in the previous layer
            let feedLayer = layers[i - 1]
            
            for j in 0..<currentLayer.neurons.count {
                let currentNeuron = currentLayer.neurons[j]
                
                for _ in 0..<feedLayer.neurons.count {
                    currentNeuron.weights.append(randomWeight())
                }
                
                currentNeuron.bias = randomWeight()
            }
        }
    }
    
    fileprivate func updateWeightsAndBias(_ inputData: [Int], learningRate: Double) {
        
        for i in 0..<layers.count {
            
            var inputs = inputData.map {
                Double($0)
            }
            
            // Update nothing for input layer
            if layers[i].position == .input { continue }
            
            // For the first layer keep the inputs from the input layer
            // and for all other layers outputs become new inputs
            if i > 1 {
                inputs = []
                for neuron in layers[i - 1].neurons {
                    inputs.append(neuron.value)
                }
            }
            
            for neuron in layers[i].neurons {
                for j in 0..<inputs.count {
                    neuron.weights[j] += inputs[j] * neuron.delta * learningRate
                }
                
                // Update bias
                neuron.bias += neuron.delta * learningRate
            }
        }
    }
    
    fileprivate func randomWeight() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
    
    fileprivate func getPreviousLayer(_ currentLayer: Layer) -> Layer? {
        
        for index in 0..<layers.count {
            if layers[index].equals(currentLayer) {
                return layers[index + 1]
            }
        }
        
        return nil
    }
    
    fileprivate func forwardPropagete(_ inputData: [Int]) -> [Double]{
        
        var inputs = inputData.map {
            Double($0)
        }
        
        for layer in layers {
            
            if layer.position != .input {
                var neuronOutput = [Double]()
                
                for neuron in layer.neurons {
                    neuron.activate(inputs)
                    neuronOutput.append(neuron.value)
                }
                
                inputs = neuronOutput
            }
        }
        
        // Return the output of the last layer
        return inputs
    }
    
    fileprivate func backwardPropagate(_ expectedData: [Int]) {
        
        // Reverse the layers order so that we start with output layer
        // and move backwards
        for layer in layers.reversed() {
            if layer.position == .output {
                for (neuron, expectedValue) in zip(layer.neurons, expectedData) {
                    neuron.calculateError(Double(expectedValue))
                }
            } else {
                // 1. Get previous layer
                // 2. Iterate over it's neurons
                // 3. For every neuron connecting to the current neuron multiply it's
                //    weight with the neuron's delta
                // 4. Sum the error of all weights connecting to the current neuron
                // 5. Calculate output
                
                let previousLayer = getPreviousLayer(layer)
                
                if let previousLayer = previousLayer {
                    for index in 0..<layer.neurons.count {
                        
                        var error = 0.0
                        for neuron in previousLayer.neurons {
                            error += neuron.weights[index] * neuron.delta
                        }
                        
                        let currentNeuron = layer.neurons[index]
                        currentNeuron.error = error
                        currentNeuron.calculateDelta()
                    }
                }
            }
        }
    }
}
