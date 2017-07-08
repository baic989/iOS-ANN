//
//  NeuralNetwork.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import Foundation

class NeuralNetwork {
    
    // MARK: - Properties -
    
    var layers: [Layer] = []
    
    // MARK: - Lifecycle -
    
    init(inputSize: Int, hiddenSize: Int, outputSize: Int) {
        layers.append(Layer(inputSize: inputSize, numberOfNeurons: hiddenSize))
        layers.append(Layer(inputSize: hiddenSize, numberOfNeurons: outputSize))
    }
    
    // MARK: - Helpers -
    
    func predictFor(inputs: [Float]) -> [Float] {
        return forwardPropagate(inputs: inputs)
    }
    
    func trainWith(inputs: [Float], targetOutput: [Float], learningRate: Float = 0.3) {
        
        // forward
        let networkOutput = forwardPropagate(inputs: inputs)
        
        // backward
        let outputError = zip(targetOutput, networkOutput).map { $0 - $1 }
        backPropagate(error: outputError, inputs: inputs, learningRate: learningRate)
    }
    
    private func forwardPropagate(inputs: [Float]) -> [Float] {
        
        var mutableInput = inputs
        
        for layer in layers {
            mutableInput = layer.forwardPropagate(inputs: mutableInput)
        }
        
        return mutableInput
    }
    
    private func backPropagate(error: [Float], inputs: [Float], learningRate: Float) {
        
        var mutableError = error
        
        for layer in layers.reversed() {
            mutableError = layer.backPropagate(error: mutableError, inputs: inputs, learningRate: learningRate)
        }
    }
}
