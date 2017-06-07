//
//  NeuralNetwork.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit
import Foundation

enum PositionInNetwork: Int {
    case input = 0
    case hidden
    case output
}

class NeuralNetwork: NSObject, NSCoding {
    
    //MARK: - Properties -
    
    // Place on disk
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("neuralNetwork")
    
    var allLayers: [Layer]
    
    fileprivate struct PropertyKey {
        static let topology = "topology"
        static let layers = "layers"
        private init() {}
    }
    
    // Network topology is an array of integers which represents the structure
    // of the network i.e. [2, 3, 2] creates a network of 3 layers. 2 input neurons
    // 3 hidden neurons and 2 output neurons
    fileprivate let networkTopology: [Int]
    
    //MARK: - Lifecycle -
    init(topology: [Int]){
        networkTopology = topology
        allLayers = []
        
        super.init()
        
        initNetwork()
    }
    
    private init(topology: [Int], layers: [Layer]) {
        self.networkTopology = topology
        self.allLayers = layers
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let topology = aDecoder.decodeObject(forKey: PropertyKey.topology) as? [Int],
              let allLayers = aDecoder.decodeObject(forKey: PropertyKey.layers) as? [Layer]
            else {
                return nil
        }
        
        self.init(topology: topology, layers: allLayers)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(networkTopology, forKey: PropertyKey.topology)
        aCoder.encode(allLayers, forKey: PropertyKey.layers)
    }
    
    // MARK: - Public -
    func trainNetwork(_ inputData: [[[Int]]], outputData: [[Int]], numberOfEpochs: Int, learningRate: Double) {
        
        for (letterIndex, letterRows) in inputData.enumerated() {
            
            if letterRows.count <= 0 { continue }
            
            for _ in 0..<numberOfEpochs {
                
                let outputRow = outputData[letterIndex]
                
                for inputRow in letterRows {
                    
                    loadDataIntoInputLayer(inputRow)
                    let result = forwardPropagete(inputRow)//.map { round($0) }
                    
                    print("Expected: \(outputRow)\n Prediction: \(result) \n\n")

                    backwardPropagate(outputRow)
                    updateWeightsAndBias(inputRow, learningRate: learningRate)
                }
            }
        }
    }
    
    func feed(_ inputData: [Int]) {
        let result = forwardPropagete(inputData)
        
        print(result)
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
            allLayers.append(inputLayer)
        } else {
            // TODO: tell VC what happened
            #if DEBUG
                print("\nERROR: Unable to init input layer!\n")
            #endif
        }
        
        // Init hidden layer
        // TODO: Fix if more than one hidden layer
        let hiddenLayer = Layer(numberOfNeurons: hiddenLayerSize, position: .hidden)
        allLayers.append(hiddenLayer)
        
        if let outputLayerSize = outputLayerSize {
            let outputLayer = Layer(numberOfNeurons: outputLayerSize, position: .output)
            allLayers.append(outputLayer)
        } else {
            #if DEBUG
                print("\nERROR: Unable to init output layer!\n")
            #endif
        }
        
        initWeightsAndBias()
    }
    
    fileprivate func loadDataIntoInputLayer(_ data: [Int]) {
        
        if let inputLayer = allLayers.first {
            
            for (neuron, dataValue) in zip(inputLayer.neurons, data) {
                neuron.neuronValue = Double(dataValue)
            }
        } else {
            // TODO: Tell VC what happened
            
            #if DEBUG
            print("\nERROR: Unable to load data into input layer!\n")
            #endif
        }
    }
    
    fileprivate func initWeightsAndBias() {
        for i in 1..<allLayers.count {
            
            let currentLayer = allLayers[i]
            
            // Each neuron in the current layer will have as many weights
            // as there are neurons in the previous layer
            let feedLayer = allLayers[i - 1]
            
            for j in 0..<currentLayer.neurons.count {
                let currentNeuron = currentLayer.neurons[j]
                
                for _ in 0..<feedLayer.neurons.count {
                    currentNeuron.neuronWeights.append(randomWeight())
                }
                
                currentNeuron.neuronBias = randomWeight()
            }
        }
    }
    
    fileprivate func updateWeightsAndBias(_ inputData: [Int], learningRate: Double) {
        
        for (layerIndex, layer) in allLayers.enumerated() {
            
            var inputs = inputData.map {
                Double($0)
            }
            
            // Update nothing for input layer
            if layer.position == .input { continue }
            
            // For the first layer keep the inputs from the input layer
            // and for all other layers outputs become new inputs
            if layerIndex > 1 {
                inputs = []
                for neuron in allLayers[layerIndex - 1].neurons {
                    inputs.append(neuron.neuronValue)
                }
            }
            
            for neuron in layer.neurons {
                for inputIndex in 0..<inputs.count {
                    neuron.neuronWeights[inputIndex] += inputs[inputIndex] * neuron.neuronDelta * learningRate
                }
                
                // Update bias
                neuron.neuronBias += neuron.neuronDelta * learningRate
            }
        }
    }
    
    fileprivate func randomWeight() -> Double {
        return Double(arc4random_uniform(2)) / 100
    }
    
    fileprivate func getPreviousLayer(_ currentIndex: Int) -> Layer? {
        
        if currentIndex > allLayers.count - 1 {
            return nil
        } else {
            return allLayers[currentIndex + 1]
        }
    }
    
    fileprivate func forwardPropagete(_ inputData: [Int]) -> [Double]{
        
        var inputs = inputData.map {
            Double($0)
        }
        
        for layer in allLayers {
            
            if layer.position != .input {
                var neuronOutput = [Double]()
                
                for neuron in layer.neurons {
                    neuron.activate(inputs)
                    neuronOutput.append(neuron.neuronValue)
                }
                
                inputs = neuronOutput
            }
        }
        
        return inputs
    }
    
    fileprivate func backwardPropagate(_ expectedData: [Int]) {
        
        // Reverse the layers order so that we start with output layer
        // and move backwards
        for (reversedIndex, layer) in allLayers.reversed().enumerated() {
            
            let trueIndex = allLayers.count - 1 - reversedIndex
            
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
                
                let previousLayer = getPreviousLayer(trueIndex)
                
                if let previousLayer = previousLayer {
                    
                    for index in 0..<layer.neurons.count {
                        var error = 0.0
                        
                        for neuron in previousLayer.neurons {
                            error += neuron.neuronWeights[index] * neuron.neuronDelta // mozda su meni utezi krivo postavljeni
                        }
                        
                        let currentNeuron = layer.neurons[index]
                        currentNeuron.neuronError = error
                        currentNeuron.calculateDelta()
                    }
                }
            }
        }
    }
}
