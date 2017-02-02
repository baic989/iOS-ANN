//
//  TrainCharacterPresenter.swift
//  ANN
//
//  Created by Hrvoje on 31/01/17.
//

import UIKit

class TrainCharacterPresenter: DrawViewControllerDelegateProtocol {
    
    weak var viewController: DrawViewController?
    
    init(viewController: DrawViewController) {
        self.viewController = viewController
    }
    
    func okButtonPressed() {
        if let viewController = viewController {
            viewController.processImage()
        }
    }
}