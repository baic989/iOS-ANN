//
//  Neuron.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit

struct Neuron {
    
    // Properties
    var weights: [Double]
    var bias: Double
    
    // Lifecycle
    init(weights: [Double], bias: Double){
        self.weights = weights
        self.bias = bias
    }
}
