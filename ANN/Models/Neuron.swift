//
//  Neuron.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

class Neuron: NSCoding {
    
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
    
    fileprivate struct PropertyKey {
        
        static let weights = "weights"
        static let bias = "bias"
        static let value = "value"
        static let error = "error"
        static let delta = "delta"
        static let position = "positon"
        
        private init() {}
    }

    // MARK: - Lifecycle -
    init(position: PositionInNetwork) {
        weights = []
        bias = 1.0
        value = 0.0
        error = 0.0
        delta = 0.0
        self.position = position
    }
    
    init(weights: [Double], bias: Double, value: Double, error: Double, delta: Double, position: PositionInNetwork) {
        self.weights = weights
        self.bias = bias
        self.value = value
        self.error = error
        self.delta = delta
        self.position = position
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let weights = aDecoder.decodeObject(forKey: PropertyKey.weights) as? [Double],
              let bias = aDecoder.decodeObject(forKey: PropertyKey.bias) as? Double,
              let value = aDecoder.decodeObject(forKey: PropertyKey.value) as? Double,
              let error = aDecoder.decodeObject(forKey: PropertyKey.error) as? Double,
              let delta = aDecoder.decodeObject(forKey: PropertyKey.delta) as? Double,
              let position = aDecoder.decodeObject(forKey: PropertyKey.position) as? PositionInNetwork
            else {
                return nil
        }
        
        self.init(weights: weights, bias: bias, value: value, error: error, delta: delta, position: position)
    }
    
    // Encode
    func encode(with aCoder: NSCoder) {

        aCoder.encode(weights, forKey: PropertyKey.weights)
        aCoder.encode(bias, forKey: PropertyKey.bias)
        aCoder.encode(value, forKey: PropertyKey.value)
        aCoder.encode(error, forKey: PropertyKey.error)
        aCoder.encode(delta, forKey: PropertyKey.delta)
        aCoder.encode(position, forKey: PropertyKey.position)
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
