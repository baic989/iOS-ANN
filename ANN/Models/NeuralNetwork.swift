//
//  NeuralNetwork.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import Foundation

class NeuralNetwork: NSObject, NSCoding {
    
    // MARK: - Properties -
    
    // Place on disk
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("neuralNetwork")
    
    var layers: [Layer] = []
    
    private struct PropertyKey {
        static let layersKey = "layersKey"
        
        private init() {}
    }
    
    // MARK: - Lifecycle -
    
    init(inputSize: Int, hiddenSize: Int, outputSize: Int) {
        layers.append(Layer(inputSize: inputSize, numberOfNeurons: hiddenSize))
        layers.append(Layer(inputSize: hiddenSize, numberOfNeurons: outputSize))
    }
    
    private init(layers: [Layer]) {
        self.layers = layers
    }
    
    // NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(layers, forKey: PropertyKey.layersKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let layers = aDecoder.decodeObject(forKey: PropertyKey.layersKey) as? [Layer] else { return nil }
        self.init(layers: layers)
    }
    
    // MARK: - Helpers -
    
    func predictFor(inputs: [Float]) -> [Float] {
        if !inputs.isEmpty {
            return forwardPropagate(inputs: inputs)
        }
        
        return []
    }
    
    func trainWith(inputs: [Float], targetOutput: [Float], learningRate: Float = 0.3) {
        
        if !inputs.isEmpty {
            // forward
            let networkOutput = forwardPropagate(inputs: inputs)
            
            // backward
            let outputError = zip(targetOutput, networkOutput).map { $0 - $1 }
            backPropagate(error: outputError, inputs: inputs, learningRate: learningRate)
        }
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
