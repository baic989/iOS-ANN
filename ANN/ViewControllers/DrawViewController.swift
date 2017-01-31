//
//  DrawViewController.swift
//  ANN
//
//  Created by polaznik on 30/01/17.
//  Copyright (c) 2017 Algebra. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    
    var presenter: DrawViewControllerDelegateProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func okButtonPressed(sender: UIButton) {
        presenter.okButtonPressed()
    }
    @IBAction func clearButtonPressed(sender: UIButton) {
        presenter.clearButtonPressed()
    }
}
