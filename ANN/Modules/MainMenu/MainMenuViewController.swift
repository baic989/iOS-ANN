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
        button.setTitleColor(.menuBackground, for: .normal)
        button.backgroundColor = .menuButton
        button.translatesAutoresizingMaskIntoConstraints = false
    
        return button
    }()
    
    let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("TEST", for: .normal)
        button.setTitleColor(.menuBackground, for: .normal)
        button.backgroundColor = .menuButton
        
        return button
    }()
    
    var closeNeuronViews: [UIView] = []
    var distantNeuronViews: [UIView] = []
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .menuBackground
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setCornerRadiusAndShadowFor(view: trainButton)
        setCornerRadiusAndShadowFor(view: testButton)
        
        for view in closeNeuronViews {
            setCornerRadiusAndShadowFor(view: view)
            drawSynapsePathsFor(view: view)
        }
    }
    
    // MARK: - Helpers -
    
    fileprivate func setupViews() {
        setupTrainButton()
        setupTestButton()
        setupNeuronViews()
    }
    
    fileprivate func setupNeuronViews() {
        
        for viewIndex in 0..<6 {
            
            let neuronView = UIView()
            var verticalOffset: CGFloat = 3
            var horizontalOffset = -self.view.frame.width/2
            var isOnTop = true
            
            neuronView.backgroundColor = .menuButton
            
            if viewIndex >= 3 {
                horizontalOffset = horizontalOffset * -1
            }
            
            if viewIndex == 1 || viewIndex == 4 {
                verticalOffset = self.view.frame.height
            }
            
            if viewIndex == 2 || viewIndex == 5 {
                isOnTop = false
            }
            
            
            setupConstraintsForMenu(view: neuronView, isOnTop: isOnTop, verticalOffset: verticalOffset, horizontalOffset: horizontalOffset, width: 55)
            closeNeuronViews.append(neuronView)
        }
    }
    
    fileprivate func drawSynapsePathsFor(view: UIView) {
        
        // ??
        let viewCenter = CGPoint(x: view.frame.midX, y: view.frame.midY)
        let buttonCenter = CGPoint(x: trainButton.frame.midX, y: trainButton.frame.midY)
        
        let path = UIBezierPath()
        path.move(to: viewCenter)
        path.addLine(to: buttonCenter)
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 5.0
        
        view.layer.addSublayer(layer)
    }
    
    fileprivate func setupTrainButton() {
        setupConstraintsForMenu(view: trainButton, isOnTop: true, verticalOffset: 5, horizontalOffset: 0, width: 75)
    }
    
    fileprivate func setupTestButton() {
        setupConstraintsForMenu(view: testButton, isOnTop: false, verticalOffset: 5, horizontalOffset: 0, width: 75)
    }
    
    fileprivate func setCornerRadiusAndShadowFor(view: UIView) {
        view.layer.cornerRadius = view.frame.width / 2
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 3
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
    }
    
    fileprivate func setupConstraintsForMenu(view: UIView, isOnTop: Bool, verticalOffset: CGFloat, horizontalOffset: CGFloat, width: CGFloat) {
        
        self.view.addSubview(view)
        
        var verticalOffsetConstant = self.view.frame.height / verticalOffset
        
        verticalOffsetConstant = isOnTop ? -verticalOffsetConstant : verticalOffsetConstant
        
        let horizontalConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: horizontalOffset)
        let verticalConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: verticalOffsetConstant)
        
        self.view.addConstraint(horizontalConstraint)
        self.view.addConstraint(verticalConstraint)
        self.view.addConstraintsWithFormat(format: "H:[v0(\(width))]", views: view)
        self.view.addConstraintsWithFormat(format: "V:[v0(\(width))]", views: view)
        
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
