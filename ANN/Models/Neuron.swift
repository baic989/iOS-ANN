//
//  Neuron.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import Foundation

class Neuron: NSObject, NSCoding {
    
    // MARK: - Properties -
    
    var output: Float = 0
    var bias: Float
    var weights: [Float]
    
    // Stored weights for backpropagation
    var storedWeights: [Float]
    
    private struct PropertyKey {
        static let biasKey = "bias"
        static let weightsKey = "weights"
        
        private init() {}
    }
    
    // MARK: - Lifecycle -
    
    init(weights: [Float], bias: Float) {
        self.weights = weights
        self.bias = bias
        storedWeights = [Float](repeating: 0, count: weights.count)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let weights = aDecoder.decodeObject(forKey: PropertyKey.weightsKey) as? [Float] else { return nil }
        self.init(weights: weights, bias: aDecoder.decodeFloat(forKey: PropertyKey.biasKey))
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bias, forKey: PropertyKey.biasKey)
        aCoder.encode(weights, forKey: PropertyKey.weightsKey)
    }
    
    // MARK: - Helpers -
    
    func activate(inputs: [Float]) -> Float {
        
        for (input, weight) in zip(inputs, weights) {
            output = output + (input * weight)
        }
        
        output = output + bias
        output = sigmoid(x: output)
        return output
    }

    func deltaFor(error: Float) -> Float {
        return (error * sigmoidDerivative(x: output))
    }

    private func sigmoid(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    
    private func sigmoidDerivative(x: Float) -> Float {
        return x * (1 - x)
    }
}

