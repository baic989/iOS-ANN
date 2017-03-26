//
//  DrawingViewController.swift
//  ANN
//
//  Created by user125215 on 3/26/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class DrawingViewController: UIViewController {
    
    // MARK: - Properties -
    var presenter: DrawingPresenterInterface!
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers -
}

// MARK: - Extensions -

extension DrawingViewController: DrawingViewInterface {
}
