//
//  MainPresenter.swift
//  CArchSwinject
//
//  Created by Ayham Hylam on 02/11/2021.
//  Copyright © 2021 Community Arch. All rights reserved.
//

import CArch

/// Протокол реализующий логику отображения данных
protocol MainRenderingLogic: RootRenderingLogic {}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Main`
final class MainPresenter: MainPresentationLogic {
    
    private weak var view: MainRenderingLogic?
    private weak var state: MainModuleStateRepresentable?
    
    init(view: MainRenderingLogic,
         state: MainModuleStateRepresentable) {
        self.view = view
        self.state = state
    }

    func encountered(_ error: Error) {
        // view?.displayErrorReasonAlert(with: error)
    }
}

// MARK: - Private methods
private extension MainPresenter {}
