//
//  MainMenuInterfaces.swift
//  ANN
//
//  Created by user125215 on 3/13/17.
//  Copyright © 2017 Hrvoje Baic. All rights reserved.
//

enum MainMenuNavigationOption {
}

protocol MainMenuWireframeInterface: WireframeInterface {
    func navigate(to option: MainMenuNavigationOption)
}

protocol MainMenuViewInterface: ViewInterface {
}

protocol MainMenuPresenterInterface: PresenterInterface {
}

protocol MainMenuInteractorInterface: InteractorInterface {
}
