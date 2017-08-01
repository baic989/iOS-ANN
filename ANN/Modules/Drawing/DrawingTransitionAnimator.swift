//
//  DrawingTransitionAnimator.swift
//  ANN
//
//  Created by Super Hrvoje on 10/07/2017.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//


import UIKit

class DrawingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var navigationOption: MainMenuNavigationOption = .train
    let animationDuration = 0.6
    var operation: UINavigationControllerOperation = .pop
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? DrawingViewController else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) as? MainMenuViewController else { return }
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        
        var button: UIButton
        switch navigationOption {
            case .test: button = toViewController.testButton
            case .train: button = toViewController.trainButton
        }
        
        UIView.animate(withDuration: animationDuration / 3, animations: {
            fromViewController.view.alpha = 0
            
        }, completion: { finished in
            containerView.bringSubview(toFront: toViewController.view)
            
            UIView.animate(withDuration: self.animationDuration / 3, animations: {
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            }, completion: { finished in
                
                UIView.animate(withDuration: self.animationDuration / 3, animations: {
                    button.titleLabel?.alpha = 1
                }, completion: { finished in
                    transitionContext.completeTransition(true)
                })
            })
        })
    }
}
