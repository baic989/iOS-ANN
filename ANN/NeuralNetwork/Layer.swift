//
//  Layer.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit

class Layer {
    
    var neurons:[Neuron]
    
    init(numberOfNeurons: Int){
        
        neurons = []

        for i in 0..<numberOfNeurons {
            
            neurons.append(Neuron())
        }
    }
}
