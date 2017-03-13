//
//  BaseWireframe.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

enum Transition {
    case root
    case push
    case present(fromViewController: UIViewController)
}

protocol WireframeInterface: class {
    func popFromNavigationCotroller(animated: Bool)
    func dismiss(animated: Bool)
}

class BaseWireframe {
    
    unowned var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func show(_ viewController: UIViewController, with transition: Transition, animated: Bool) {
        
        switch transition {
        case .push:
            navigationController.pushViewController(viewController, animated: animated)
        case .present(let fromViewController):
            navigationController.viewControllers = [viewController]
            fromViewController.present(viewController, animated: animated, completion: nil)
        case .root:
            navigationController.setViewControllers([viewController], animated: animated)
        }
    }
}

extension BaseWireframe: WireframeInterface {
    
    func popFromNavigationCotroller(animated: Bool) {
        let _ = navigationController.popViewController(animated: animated)
    }
    
    func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
}
