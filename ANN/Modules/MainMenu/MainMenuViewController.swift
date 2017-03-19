//
//  MainMenuViewController.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class MainMenuViewController: UIViewController {
    
    var presenter: MainMenuPresenterInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    // MARK: - Override -
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Extensions -

extension MainMenuViewController: MainMenuViewInterface {
}
