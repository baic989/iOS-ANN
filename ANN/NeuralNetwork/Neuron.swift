//
//  Neuron.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit

class Neuron {
    
    // MARK: - Properties -
    var weights: [Double]
    var bias: Double
    var value: Double
    var error: Double

    // MARK: - Lifecycle -
    init() {
        weights = []
        bias = 1.0
        value = 0.0
        error = 0.0
    }
    
    // MARK: - Helpers -
    func activate(inputs: [Double]) {
        
        value = bias
        
        for (weight, input) in Zip2(weights, inputs) {
            value += weight * input
        }
        
        value = sigmoid(value)
    }
    
    func sigmoid(input: Double) -> Double {
        return 1 / (1 + pow(M_E, -input))
    }
}
