//
//  MainRenderer.swift
//  CArchSwinject
//
//  Created by Ayham Hylam on 02/11/2021.
//  Copyright © 2021 Community Arch. All rights reserved.
//

import CArch

/// Протокол взаимодействия пользователя с модулем
protocol MainRendererUserInteraction: AnyUserInteraction {}

/// Объект содержащий логику отображения данных 
final class MainRenderer: NSObject, UIRenderer {    
    
    // MARK: - Renderer model
    typealias ModelType = Model
    
    struct Model: UIModel {}

    // MARK: - Outlet properties
    @IBOutlet var delegate: AnyObject? {
        get {
            interactional as AnyObject
        }
        set {
            interactional = newValue as? MainUserInteraction
        }
    }

    // MARK: - Private properties
    private weak var interactional: MainUserInteraction?
    
    // MARK: - Public methods
    func set(content: MainRenderer.ModelType) {}
}

// MARK: - Renderer + IBAction
private extension MainRenderer {}

// MARK: - Private methods
private extension MainRenderer {}
