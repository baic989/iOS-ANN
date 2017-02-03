//
//  MainViewController.swift
//  ANN
//
//  Created by Hrvoje on 24/01/17.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions -
    @IBAction func feedSampleDataButtonPressed(sender: UIButton) {
        
        let drawViewController = initDrawViewController()
        let drawViewPresenter = TrainCharacterPresenter(viewController: drawViewController)
        drawViewController.presenter = drawViewPresenter
        
        presentViewController(drawViewController, animated: true, completion: nil)
    }
    
    @IBAction func trainNetworkButtonPressed(sender: UIButton) {
    }
    
    @IBAction func testNetworkButtonPressed(sender: UIButton) {
        
        let drawViewController = initDrawViewController()
        let drawViewPresenter = ClassifyCharacterPresenter(viewController: drawViewController)
        drawViewController.presenter = drawViewPresenter
        
        presentViewController(drawViewController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation -
    private func initDrawViewController() -> DrawViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let drawViewController = storyboard.instantiateViewControllerWithIdentifier("DrawViewController") as DrawViewController
        
        return drawViewController
    }
    
    // MARK: - Setup -
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
