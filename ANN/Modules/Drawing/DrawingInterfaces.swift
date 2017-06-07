//
//  DrawingInterfaces.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

enum DrawingNavigationOption {
}

protocol DrawingWireframeInterface: WireframeInterface {
    func navigate(to option: DrawingNavigationOption)
}

protocol DrawingViewInterface: ViewInterface {
    var trainButton: UIButton { get set }
    var characterPickerView: UIPickerView { get set }
    func processImage()
    func classifyImage()
}

protocol DrawingPresenterInterface: PresenterInterface {
    func setupUI()
    func okButtonPressed()
}

protocol DrawingInteractorInterface: InteractorInterface {
}
