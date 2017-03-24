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
        button.addTarget(self, action: #selector(trainButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(trainButtonTouchUp), for: .touchUpInside)
    
        return button
    }()
    
    let testButton: UIButton = {
        let button = UIButton()
        button.setTitle("TEST", for: .normal)
        button.setTitleColor(.menuBackground, for: .normal)
        button.backgroundColor = .menuButton
        button.addTarget(self, action: #selector(testButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(testButtonTouchUp), for: .touchUpInside)
        
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
        
        view.bringSubview(toFront: trainButton)
        view.bringSubview(toFront: testButton)
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
        
        // Get points for bezier path relative to superview
        // Point for our neuron view
        let viewRectInSuperview = view.convert(view.frame, from: self.view)
        let viewPointInSuperview = CGPoint(x: viewRectInSuperview.midX, y: viewRectInSuperview.midY)
        
        // Point for train button
        let trainButtonRectInSuperview = view.convert(trainButton.frame, from: self.view)
        let trainButtonPointInSuperview = CGPoint(x: trainButtonRectInSuperview.midX, y: trainButtonRectInSuperview.midY)
        
        // Point for test button
        let testButtonRectInSuperview = view.convert(testButton.frame, from: self.view)
        let testButtonPointInSuperview = CGPoint(x: testButtonRectInSuperview.midX, y: testButtonRectInSuperview.midY)
        
        // Add path from views to train button
        let trainPath = UIBezierPath()
        trainPath.move(to: viewPointInSuperview)
        trainPath.addLine(to: trainButtonPointInSuperview)
        trainPath.close()
        
        // Add path for views to test button
        let testPath = UIBezierPath()
        testPath.move(to: viewPointInSuperview)
        testPath.addLine(to: testButtonPointInSuperview)
        testPath.close()
        
        // Make layer for train button
        let trainLayer = CAShapeLayer()
        trainLayer.path = trainPath.cgPath
        trainLayer.strokeColor = UIColor.menuButton.cgColor
        trainLayer.lineWidth = 3.0
        
        // Make lazer for test button
        let testLayer = CAShapeLayer()
        testLayer.path = testPath.cgPath
        testLayer.strokeColor = UIColor.menuButton.cgColor
        testLayer.lineWidth = 3.0
        
        // Add layers to main view
        view.layer.addSublayer(trainLayer)
        view.layer.addSublayer(testLayer)
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
    
    fileprivate func touchDownAnimationFor(button: UIButton, withCompletion completion: ((_ finished: Bool) -> ())?) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
            button.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        }) { finished in
            completion?(finished)
        }
    }
    
    fileprivate func touchUpAnimationFor(button: UIButton, withCompletion completion: @escaping (_ finished: Bool) -> ()) {
        
        UIView.animate(withDuration: 0.1) { 
            button.titleLabel?.alpha = 0.0
        }

        UIView.animate(withDuration: 0.3, animations: {
            button.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
        }) { finished in
            completion(finished)
        }
    }
    
    // MARK: - Button actions -
    func trainButtonTouchDown() {
        touchDownAnimationFor(button: trainButton, withCompletion: nil)
    }
    
    func trainButtonTouchUp() {
        trainButton.layer.zPosition = 1
        
        touchUpAnimationFor(button: trainButton) { [weak self] finished in
            self?.presenter.didPressTrainButton()
        }
    }
    
    func testButtonTouchDown() {
        touchDownAnimationFor(button: testButton, withCompletion: nil)
    }
    
    func testButtonTouchUp() {
        testButton.layer.zPosition = 1
        
        touchUpAnimationFor(button: testButton) { [weak self] finished in
            self?.presenter.didPressTestButton()
        }
    }
    
    // MARK: - Override -
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - Extensions -

extension MainMenuViewController: MainMenuViewInterface {
}
