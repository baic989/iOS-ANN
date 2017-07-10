//
//  DrawingWireframe.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class DrawingWireframe: BaseWireframe {
    
    // MARK: - Module setup -
    
    func configureModule(with viewController: DrawingViewController, navigationOption: MainMenuNavigationOption) {
        let interactor = DrawingInteractor()
        let presenter = DrawingPresenter(wireframe: self, view: viewController, interactor: interactor, navigationOption: navigationOption)
        viewController.presenter = presenter
    }
    
    func show(with transition: Transition, navigationOption: MainMenuNavigationOption, animated: Bool = true) {
        let moduleViewController = DrawingViewController()
        configureModule(with: moduleViewController, navigationOption: navigationOption)
        
        show(moduleViewController, with: transition, animated: animated)
    }
    
    // MARK: - Navigation -
    fileprivate func navigateBack() {
        popFromNavigationCotroller(animated: true)
    }
}

// MARK: - Extensions -

extension DrawingWireframe: DrawingWireframeInterface {
    
    func navigate(to option: DrawingNavigationOption) {
        switch option {
        case .back:
            navigateBack()
        }
    }
}
