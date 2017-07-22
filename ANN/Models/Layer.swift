//
//  Layer.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import Foundation

class Layer: NSObject, NSCoding {
    
    // MARK: - Properties -
    private var neurons: [Neuron]
    private var inputSize: Int
    
    private struct PropertyKey {
        static let neuronsKey = "neuronsKey"
        static let inputSizeKey = "inputSizeKey"
        
        private init() {}
    }
    
    // MARK: - Lifecycle -
    
    init(inputSize: Int, numberOfNeurons: Int) {
        
        neurons = []
        self.inputSize = inputSize
        
        let sign = Float(arc4random_uniform(3) > 1 ? 1 : -1)
        let bias = Float(arc4random_uniform(2))
        
        for _ in 0..<numberOfNeurons {
            
            var weights: [Float] = []
            
            for _ in 0..<inputSize {
                weights.append(Float(arc4random_uniform(2)) * sign)
            }
            
            neurons.append(Neuron(weights: weights, bias: bias))
        }
    }
    
    private init(inputSize: Int, neurons: [Neuron]) {
        self.inputSize = inputSize
        self.neurons = neurons
    }
    
    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(inputSize, forKey: PropertyKey.inputSizeKey)
        aCoder.encode(neurons, forKey: PropertyKey.neuronsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let neurons = aDecoder.decodeObject(forKey: PropertyKey.neuronsKey) as? [Neuron] else { return nil }
        self.init(inputSize: aDecoder.decodeInteger(forKey: PropertyKey.inputSizeKey), neurons: neurons)
    }
    
    // MARK: - Helpers -
    
    func forwardPropagate(inputs: [Float]) -> [Float] {
        
        var outputs: [Float] = []
        
        for neuron in neurons {
            outputs.append(neuron.activate(inputs: inputs))
        }
        
        return outputs
    }
    
    func backPropagate(error: [Float], inputs: [Float], learningRate: Float) -> [Float] {
        
        var errorsToPropagate = [Float](repeating: 0, count: inputSize)
        
        for (indexN, neuron) in neurons.enumerated() {
            
            // neuron ne zna svoj error
            let delta = neuron.deltaFor(error: error[indexN])
            
            for (indexW, weight) in neuron.weights.enumerated() {
                errorsToPropagate[indexW] = errorsToPropagate[indexW] + weight * delta
                let deltaWeight = inputs[indexW] * delta * learningRate
                neuron.weights[indexW] = neuron.weights[indexW] + neuron.storedWeights[indexW] * neuron.bias + deltaWeight
                neuron.storedWeights[indexW] = deltaWeight
            }
        }
        
        return errorsToPropagate
    }
}
