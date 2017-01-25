//
//  Neuron.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit

class Neuron {
    
    // Properties
    var weights: [Double]
    var bias: Double
    var value: Double
    
    init() {
        weights = []
        bias = 1.0
        value = 0.0
    }
}
