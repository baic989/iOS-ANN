//
//  ClassifyCharacterPresenter.swift
//  ANN
//
//  Created by Hrvoje on 31/01/17.
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
}
