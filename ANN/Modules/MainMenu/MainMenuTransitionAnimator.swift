//
//  MainMenuTransitionAnimator.swift
//  ANN
//
//  Created by Super Hrvoje on 08/07/2017.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

import UIKit

class MainMenuTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var navigationOption: MainMenuNavigationOption = .train
    let animationDuration = 0.4
    var operation: UINavigationControllerOperation = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTestPushTransitionWith(transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    func animateTrainPushTransitionWith(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? MainMenuViewController else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) as? DrawingViewController else { return }
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        
        let scale = (fromViewController.view.frame.height / fromViewController.trainButton.frame.height) * 1.5
        toViewController.view.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        toViewController.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.01) {
            fromViewController.trainButton.titleLabel?.alpha = 0
        }
        
        UIView.animate(withDuration: animationDuration / 2, animations: {
            fromViewController.trainButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }, completion: { finished in
            
            containerView.bringSubview(toFront: toViewController.view)
            
            UIView.animate(withDuration: self.animationDuration / 2, animations: {
                
                toViewController.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                toViewController.view.alpha = 1
                
            }, completion: { finished in
                transitionContext.completeTransition(true)
            })
        })
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .push {
            switch navigationOption {
            case .train:
                animateTrainPushTransitionWith(transitionContext: transitionContext)
            case .test:
                animateTestPushTransitionWith(transitionContext: transitionContext)
            }
        }
    }
}
