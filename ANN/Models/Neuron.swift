//
//  Neuron.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import Foundation

class Neuron: NSObject {
    
    // MARK: - Properties -
    
    var output: Float = 0
    var bias: Float
    var weights: [Float]
    var previousWeights: [Float]
    
    // MARK: - Lifecycle -
    
    init(weights: [Float], bias: Float) {
        self.weights = weights
        self.bias = bias
        previousWeights = [Float](repeating: 0, count: weights.count)
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

    func sigmoid(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    
    func sigmoidDerivative(x: Float) -> Float {
        return x * (1 - x)
    }
}
