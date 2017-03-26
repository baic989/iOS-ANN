//
//  DrawingViewController.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class DrawingViewController: UIViewController {
    
    var presenter: DrawingPresenterInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Extensions -

extension DrawingViewController: DrawingViewInterface {
}
