//
//  Layer.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit

enum LayerType {
    case inputLayer
    case hiddenLayer
    case outputLayer
}

class Layer {
    
    var neurons:[Neuron]
    var type: LayerType
    
    init(numberOfNeurons: Int, type: LayerType){
        
        neurons = []
        self.type = type

        for i in 0..<numberOfNeurons {
            
            neurons.append(Neuron())
        }
    }
}
