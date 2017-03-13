//
//  Neuron.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

class Neuron {
    
    // MARK: - Properties -
    var weights: [Double]
    var bias: Double
    // Value is output
    var value: Double
    // Error is the error in the output
    var error: Double
    // Delta is the proposed change to fix the error
    var delta: Double
    var position: PositionInNetwork

    // MARK: - Lifecycle -
    init(position: PositionInNetwork) {
        weights = []
        bias = 1.0
        value = 0.0
        error = 0.0
        delta = 0.0
        self.position = position
    }
    
    // MARK: - Helpers -
    func activate(_ inputs: [Double]) {
        
        value = bias
        
        for (weight, input) in zip(weights, inputs) {
            value += weight * input
        }
        
        value = sigmoid(value)
    }
    
    func calculateError(_ expectedOutput: Double) {
        
        if position == .output {
            error = expectedOutput - value
        }
        
        calculateDelta()
    }
    
    func calculateDelta() {
        delta = error * sigmoidDerivative(value)
    }
    
    fileprivate func sigmoid(_ input: Double) -> Double {
        return 1 / (1 + pow(M_E, -input))
    }
    
    fileprivate func sigmoidDerivative(_ output: Double) -> Double {
        return output * (1.0 - output)
    }
    
    // Use as alternative algorithm
//    /// Hyperbolic tangent activation function.
//    private func hyperbolicTangent(x: Float) -> Float {
//        return tanh(x)
//    }
//    
//    /// Derivative for the hyperbolic tangent activation function.
//    private func hyperbolicTangentDerivative(y: Float) -> Float {
//        return 1 - (y * y)
//    }
}
