//
//  MainMenuPresenter.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class MainMenuPresenter {
    
    // MARK: - Private properties -
    
    fileprivate weak var _view: MainMenuViewInterface?
    fileprivate var _interactor: MainMenuInteractorInterface
    fileprivate var _wireframe: MainMenuWireframeInterface
    
    // MARK: - Lifecycle -
    
    init (wireframe: MainMenuWireframeInterface, view: MainMenuViewInterface, interactor: MainMenuInteractorInterface) {
        _wireframe = wireframe
        _view = view
        _interactor = interactor
    }
    
}

// MARK: - Extensions -

extension MainMenuPresenter: MainMenuPresenterInterface {
    
    func didPressTrainButton() {
        _wireframe.navigate(to: .train)
    }
    
    func didPressTestButton() {
        _wireframe.navigate(to: .test)
    }
}
