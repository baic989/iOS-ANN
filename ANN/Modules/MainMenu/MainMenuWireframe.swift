//
//  MainMenuWireframe.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class MainMenuWireframe: BaseWireframe {
    
    // MARK: - Module setup -
    
    func configureModule(with viewController: MainMenuViewController) {
        let interactor = MainMenuInteractor()
        let presenter = MainMenuPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
    }
    
    func show(with transition: Transition, animated: Bool = true) {
        let moduleViewController = MainMenuViewController()
        configureModule(with: moduleViewController)
        
        show(moduleViewController, with: transition, animated: animated)
    }
}

// MARK: - Extensions -

extension MainMenuWireframe: MainMenuWireframeInterface {
    
    func navigate(to option: MainMenuNavigationOption) {
        let drawingWireframe = DrawingWireframe(navigationController: navigationController)
        drawingWireframe.show(with: .push, navigationOption: option)
    }
    
}
