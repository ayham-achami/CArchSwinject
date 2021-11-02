//
//  MainView.swift
//  CArchSwinject
//
//  Created by Ayham Hylam on 02/11/2021.
//  Copyright © 2021 Community Arch. All rights reserved.
//

import CArch
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
protocol MainProvisionLogic: RootProvisionLogic {}

/// Все взаимодействия пользователя с модулем
typealias MainUserInteraction = MainRendererUserInteraction // & <#SecondUserInteractionIfNeeded#>

/// Объект содержаний логику отображения данных
final class MainViewController: UIViewController {

    // MARK: - Module reference
    private let moduleReference = assembly(MainAssembly.self)

    // MARK: - Injected properties
    var provider: MainProvisionLogic!
    var router: MainRoutingLogic!

    // MARK: - Outlet Renderers
    @IBOutlet private var renderer: MainRenderer!

    /// состояние модуля `Main`
    private var state = MainModuleState()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        do {
            try router.prepare(for: segue, sender: sender)
        } catch {
            assertionFailure("Error: [\(error)] Could not to prepare for segue \(segue)")
        }
    }
}

// MARK: - Main + Initializer
extension MainViewController: AnyModuleInitializer {
    
    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(MainModuleState.InitialStateType.self)
    }
}

// MARK: - Main + StateRepresentable
extension MainViewController: MainModuleStateRepresentable {
    
    var readOnly: MainModuleReadOnlyState {
    	state
    }
}

// MARK: - Main + RenderingLogic
extension MainViewController: MainRenderingLogic {}

// MARK: - Main + UserInteraction
extension MainViewController: MainUserInteraction {}
