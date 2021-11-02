//
//  MainRouter.swift
//  CArchSwinject
//
//  Created by Ayham Hylam on 02/11/2021.
//  Copyright © 2021 Community Arch. All rights reserved.
//

import CArch

/// Протокол организующий логику переходов от модуля `Main` в другие модули
protocol MainRoutingLogic: RootRoutingLogic {}

/// Объект содержаний логику переходов от модуля `Main` в другие модули
final class MainRouter: MainRoutingLogic {
    
    private unowned let transitionController: TransitionController
    
    init(transitionController: TransitionController) {
        self.transitionController = transitionController
    }

    func showErrorAlert(_ message: String) {
        transitionController.displayErrorAlert(with: message)
    }
}
