//
//  DrawingPresenter.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class DrawingPresenter {
    
    // MARK: - Private properties -
    
    fileprivate weak var _view: DrawingViewInterface?
    fileprivate var _interactor: DrawingInteractorInterface
    fileprivate var _wireframe: DrawingWireframeInterface
    fileprivate var _navigationOption: MainMenuNavigationOption
    
    // MARK: - Lifecycle -
    
    init (wireframe: DrawingWireframeInterface, view: DrawingViewInterface, interactor: DrawingInteractorInterface, navigationOption: MainMenuNavigationOption) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
        _navigationOption = navigationOption
    }
}

// MARK: - Extensions -

extension DrawingPresenter: DrawingPresenterInterface {
    
    func setupUI() {
        
        switch _navigationOption {
        case .testScreen:
            _view?.trainButton.isHidden = true
            _view?.characterPickerView.isHidden = true
        case .trainScreen:
            _view?.trainButton.isHidden = false
            _view?.characterPickerView.isHidden = false
        }
    }
    
    internal func okButtonPressed() {
        switch _navigationOption {
        case .testScreen:
            _view?.classifyImage()
        case .trainScreen:
            _view?.processImage()
        }
    }

}
