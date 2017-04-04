//
//  DrawingInterfaces.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

enum DrawingNavigationOption {
}

protocol DrawingWireframeInterface: WireframeInterface {
    func navigate(to option: DrawingNavigationOption)
}

protocol DrawingViewInterface: ViewInterface {
    func processImage()
    func classifyImage()
}

protocol DrawingPresenterInterface: PresenterInterface {
    func okButtonPressed()
}

protocol DrawingInteractorInterface: InteractorInterface {
}
