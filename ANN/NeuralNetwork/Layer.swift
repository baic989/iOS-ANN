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
    var position: PositionInNetwork
    
    init(numberOfNeurons: Int, position: PositionInNetwork){
        
        neurons = []
        self.position = position

        for i in 0..<numberOfNeurons {
            
            neurons.append(Neuron(position: position))
        }
    }
}
