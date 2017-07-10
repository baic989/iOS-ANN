//
//  DrawingTransitionAnimator.swift
//  ANN
//
//  Created by Super Hrvoje on 10/07/2017.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//


import UIKit

class DrawingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var navigationOption: DrawingNavigationOption = .mainMenu
    let animationDuration = 0.4
    var operation: UINavigationControllerOperation = .push
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? DrawingViewController else { return }
        guard let toViewController = transitionContext.viewController(forKey: .to) as? MainMenuViewController else { return }
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(fromViewController.view)
        
        let scale = (fromViewController.view.frame.height / fromViewController.trainButton.frame.height) * 1.5
        toViewController.view.alpha = 0.0
        
        
        UIView.animate(withDuration: 0.01) {
            fromViewController.trainButton.titleLabel?.alpha = 1
        }
        
        UIView.animate(withDuration: animationDuration / 2, animations: {
            fromViewController.trainButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }, completion: { finished in
            
            containerView.bringSubview(toFront: toViewController.view)
            
            UIView.animate(withDuration: self.animationDuration / 2, animations: {
                
                toViewController.view.alpha = 1
                
            }, completion: { finished in
                transitionContext.completeTransition(true)
            })
        })
    }
}
