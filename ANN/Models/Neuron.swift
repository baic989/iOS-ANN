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
    
    var neuronOutput: Float = 0
    var neuronError: Float = 0
    var neuronBias: Float = 0
    var neuronWeight: Float
    
    private struct PropertyKey {
        static let weight = "neuronWeight"
        static let bias = "neuronBias"
        static let error = "neuronError"
        private init() {}
    }
    
    // MARK: - Lifecycle -
    
    init(weight: Float) {
        neuronWeight = weight
    }
    
    //    private init(weight: Double, bias: Double, value: Double, error: Double, delta: Double, position: PositionInNetwork) {
    //        neuronWeight = weight
    //        neuronBias = bias
    //        neuronError = error
    //        neuronDelta = delta
    //        self.neuronPosition = position
    //
    //        super.init()
    //    }
    
    //    required convenience init?(coder aDecoder: NSCoder) {
    
    //        guard let position = PositionInNetwork(rawValue: aDecoder.decodeInteger(forKey: PropertyKey.position)) else { return }
    //        let weight = aDecoder.decodeDouble(forKey: PropertyKey.weight)
    //        let bias = aDecoder.decodeDouble(forKey: PropertyKey.bias)
    //        let error = aDecoder.decodeDouble(forKey: PropertyKey.error)
    //        let delta = aDecoder.decodeDouble(forKey: PropertyKey.delta)
    //
    //        self.init(weight: weight, bias: bias, value: value, error: error, delta: delta, position: position)
//}

    // Encode
    //    func encode(with aCoder: NSCoder) {
    //        aCoder.encode(neuronWeight, forKey: PropertyKey.weight)
    //        aCoder.encode(neuronBias, forKey: PropertyKey.bias)
    //        aCoder.encode(neuronError, forKey: PropertyKey.error)
    //        aCoder.encode(neuronDelta, forKey: PropertyKey.delta)
    //        aCoder.encode(neuronPosition.rawValue, forKey: PropertyKey.position)
    //    }
    
    // MARK: - Helpers -
    func activate(input: Float) {
        neuronOutput = input * neuronWeight + neuronBias
    }
    
    //    func calculateError(_ expectedOutput: Double) {
    //        
//        if neuronPosition == .output {
//            neuronError = expectedOutput - neuronValue
//            neuronDelta = neuronError
//        } else {
//            calculateDelta()
//        }
//    }

//    func calculateDelta() {
//        neuronDelta = neuronError * sigmoidDerivative(x: neuronValue)
//    }

    fileprivate func sigmoid(x: Double) -> Double {
        return Double(1 / (1 + exp(-x)))
    }
    
    fileprivate func sigmoidDerivative(x: Double) -> Double {
        return Double(x * (1 - x))
    }
}
