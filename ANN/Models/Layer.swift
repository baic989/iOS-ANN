//
//  Layer.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

class Layer: NSCoder {
    
    static var id: Int = 0
    var neurons:[Neuron]
    var position: PositionInNetwork
    
    fileprivate struct PropertyKey {
        static let neurons = "neurons"
        static let position = "position"
    }
    
    // MARK: - Lifecycle -
    init(numberOfNeurons: Int, position: PositionInNetwork){
        
        Layer.id = Layer.id + 1
        neurons = []
        self.position = position

        for _ in 0..<numberOfNeurons {
            
            neurons.append(Neuron(position: position))
        }
    }
    
    private init(neurons: [Neuron], position: PositionInNetwork) {
        Layer.id = Layer.id + 1
        self.neurons = neurons
        self.position = position
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let neurons = aDecoder.decodeObject(forKey: PropertyKey.neurons) as? [Neuron],
              let position = aDecoder.decodeObject(forKey: PropertyKey.position) as? PositionInNetwork
            else {
                return nil
        }
        
        self.init(neurons: neurons, position: position)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(neurons, forKey: PropertyKey.neurons)
        aCoder.encode(position, forKey: PropertyKey.position)
    }
}
