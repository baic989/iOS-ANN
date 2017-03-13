//
//  ClassifyCharacterPresenter.swift
//  ANN
//
//  Created by Hrvoje on 31/01/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

class ClassifyCharacterPresenter: DrawViewControllerDelegateProtocol {
    
    weak var viewController: DrawViewController?
    
    init(viewController: DrawViewController) {
        self.viewController = viewController
    }
    
    func okButtonPressed() {
        if let viewController = viewController {
            viewController.classifyImage()
        }
    }
}
