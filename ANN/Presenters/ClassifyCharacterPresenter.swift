//
//  ClassifyCharacterPresenter.swift
//  ANN
//
//  Created by polaznik on 31/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit

class ClassifyCharacterPresenter: DrawViewControllerDelegateProtocol {
    
    weak var viewController: DrawViewController?
    
    init(viewController: DrawViewController) {
        self.viewController = viewController
    }
    
    func okButtonPressed() {
        //Implement me
    }
    
    func clearButtonPressed() {
        // Implement me
    }
}
