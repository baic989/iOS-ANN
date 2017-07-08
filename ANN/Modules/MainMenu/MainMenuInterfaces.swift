//
//  MainMenuInterfaces.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

enum MainMenuNavigationOption {
    case train
    case test
}

protocol MainMenuWireframeInterface: WireframeInterface {
    func navigate(to option: MainMenuNavigationOption)
}

protocol MainMenuViewInterface: ViewInterface {
}

protocol MainMenuPresenterInterface: PresenterInterface {
    func didPressTrainButton()
    func didPressTestButton()
}

protocol MainMenuInteractorInterface: InteractorInterface {
}
