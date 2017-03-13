//
//  PresenterInterface.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

protocol PresenterInterface: class {
    func viewDidLoad()
    func viewWillAppear(animated: Bool)
    func viewDidAppear(animated: Bool)
    func viewWillDisappear(animated: Bool)
    func viewDidDisappear(animated: Bool)
}

extension PresenterInterface {
    
    func viewDidLoad() {
        fatalError("Not yet implemented.")
    }
    
    func viewWillAppear(animated: Bool) {
        fatalError("Not yet implemented.")
    }
    
    func viewDidAppear(animated: Bool) {
        fatalError("Not yet implemented.")
    }
    
    func viewWillDisappear(animated: Bool) {
        fatalError("Not yet implemented.")
    }
    
    func viewDidDisappear(animated: Bool) {
        fatalError("Not yet implemented.")
    }
}
