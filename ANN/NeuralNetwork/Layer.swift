//
//  Layer.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

// TODO: Refactor
// The version of Swift that I'm stuck with doesn't
// support static/class variables ...
private var class_id: Int = 0

class Layer {
    
    var id: Int
    var neurons:[Neuron]
    var position: PositionInNetwork
    
    init(numberOfNeurons: Int, position: PositionInNetwork){
        
        id = class_id + 1
        neurons = []
        self.position = position

        for _ in 0..<numberOfNeurons {
            
            neurons.append(Neuron(position: position))
        }
    }
    
    func equals(_ other: Layer) -> Bool {
        return id == other.id
    }
}
