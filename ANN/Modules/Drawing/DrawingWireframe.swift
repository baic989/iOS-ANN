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
    
    func configureModule(with viewController: DrawingViewController) {
        let interactor = DrawingInteractor()
        let presenter = DrawingPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
    }
    
    func show(with transition: Transition, animated: Bool = true) {
        let moduleViewController = DrawingViewController()
        configureModule(with: moduleViewController)
        
        show(moduleViewController, with: transition, animated: animated)
    }
}

// MARK: - Extensions -

extension DrawingWireframe: DrawingWireframeInterface {
    
    func navigate(to option: DrawingNavigationOption) {
        
    }
}
