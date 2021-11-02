//
//  MainState.swift
//  CArchSwinject
//
//  Created by Ayham Hylam on 02/11/2021.
//  Copyright © 2021 Community Arch. All rights reserved.
//

import CArch

/// Протокол передающий доступ к некоторым свойствам состояние модуля `Main` как только для чтения
protocol MainModuleReadOnlyState: AnyReadOnlyState {}

/// Протокол передающий доступ к состоянию модуля как только для чтения
protocol MainModuleStateRepresentable: AnyModuleStateRepresentable {
    
    var readOnly: MainModuleReadOnlyState { get }
}

/// Состояние модуля `Main`
struct MainModuleState: ModuleState {    
    
    struct InitialState: ModuleInitialState {}
    
    struct FinalState: ModuleFinalState {}
    
    typealias InitialStateType = InitialState
    typealias FinalStateType = FinalState
    
    var initialState: MainModuleState.InitialStateType?
    var finalState: MainModuleState.FinalStateType?
}

// MARK: - MainModuleState +  ReadOnly
extension MainModuleState: MainModuleReadOnlyState {}
