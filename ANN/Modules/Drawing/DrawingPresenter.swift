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
}