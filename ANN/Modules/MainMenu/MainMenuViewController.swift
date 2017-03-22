//
//  MainMenuViewController.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

final class MainMenuViewController: UIViewController {
    
    // MARK: - Properties -
    
    var presenter: MainMenuPresenterInterface!
    
    let trainButton: UIButton = {
        let button = UIButton()
        button.setTitle("TRAIN", for: .normal)
//        button.setTitleColor(.menuButtonPurple, for: .normal)
        button.backgroundColor = .menuButton
        button.translatesAutoresizingMaskIntoConstraints = false
    
        return button
    }()
    
    let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("TEST", for: .normal)
        button.setTitleColor(.menuBackground, for: .normal)
        button.backgroundColor = .menuButton
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .menuBackground
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCornerRadiusAndShadowFor(view: trainButton)
        setCornerRadiusAndShadowFor(view: testButton)
    }
    
    // MARK: - Helpers -
    
    fileprivate func setupViews() {
        setupTrainButton()
        setupTestButton()
    }
    
    fileprivate func setupTrainButton() {
        setupConstraintsForMenu(button: trainButton, isOnTop: true)
    }
    
    fileprivate func setupTestButton() {
        setupConstraintsForMenu(button: testButton, isOnTop: false)
    }
    
    fileprivate func setCornerRadiusAndShadowFor(view: UIView) {
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
    }
    
    fileprivate func setupConstraintsForMenu(button: UIButton, isOnTop: Bool) {
        view.addSubview(button)
        
        var verticalOffset = view.frame.height / 5
        
        verticalOffset = isOnTop ? -verticalOffset : verticalOffset
        
        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: verticalOffset)
        
        view.addConstraint(horizontalConstraint)
        view.addConstraint(verticalConstraint)
        view.addConstraintsWithFormat(format: "H:[v0(100)]", views: button)
        view.addConstraintsWithFormat(format: "V:[v0(100)]", views: button)
        
        horizontalConstraint.isActive = true
        verticalConstraint.isActive = true
    }
    
    // MARK: - Override -
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Extensions -

extension MainMenuViewController: MainMenuViewInterface {
}
