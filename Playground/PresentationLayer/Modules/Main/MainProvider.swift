//
//  MainProvider.swift
//  CArchSwinject
//
//  Created by Ayham Hylam on 02/11/2021.
//  Copyright © 2021 Community Arch. All rights reserved.
//

import CArch

/// Протокол взаимодействия с MainPresenter
protocol MainPresentationLogic: RootPresentationLogic {}

/// Объект содержаний логику получения данных из слоя бизнес логики 
/// все типы данных передаются MainPresenter как `UIModel`
final class MainProvider: MainProvisionLogic {
    
    private let presenter: MainPresentationLogic
    
    /// Инициализация провайдера модуля `Main`
    /// - Parameter presenter: `MainPresenter`
    init(presenter: MainPresentationLogic) {
        self.presenter = presenter
    }
}
