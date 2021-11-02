//
//  MainAssembly.swift
//  CArchSwinject
//
//  Created by Ayham Hylam on 02/11/2021.
//  Copyright © 2021 Community Arch. All rights reserved.
//

import CArch

/// Пространство имен модуля Main
struct MainModule {
    
    /// Объект содержащий логику преобразования из `UIStoryboard` и `UIViewController`
    final class Convertor: ModuleStoryboardConvertor {
          
        static var storyboardName: UIStoryboard.Name {
            UIStoryboard.Name(rawValue: "Main")!
        }
        
        static var viewControllerName: UIViewController.Name {
            UIViewController.Name(class: MainViewController.self)!
        }
    }

    /// Объект содержащий логику создание модуля `Main` 
    /// с чистой иерархии (просто ViewController) 
    final class Builder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MainModuleState.InitialStateType
        
        func build(with initialState: InitialStateType) -> CArchModule {
            let module = Convertor.viewController(type: MainViewController.self)!
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            Convertor.viewController(type: MainViewController.self)!
        }
    }
}

/// Объект содержащий логику внедрение зависимости компонентов модула `Main`
final class MainAssembly: StoryboardModuleAssembly {
    
    required init() {
        print("MainModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: DIStoryboardContainer) {
        container.setInitCompleted(for: MainViewController.self) { (resolver, controller) in
            guard let presenter = resolver.unravel(MainPresentationLogic.self, 
                                                    arguments: controller as MainRenderingLogic,
                                                    controller as MainModuleStateRepresentable) else {
                fatalError("Could not to build Main module, module Presenter is nil")
            }
            controller.provider = resolver.unravel(MainProvisionLogic.self,
                                                   argument: presenter as MainPresentationLogic)
            controller.router = resolver.unravel(MainRoutingLogic.self,
                                                 argument: controller as TransitionController)
        }
    }
    
    func registerProvider(in container: DIStoryboardContainer) {
        container.record(MainProvisionLogic.self) { (_, presenter: MainPresentationLogic) in
            MainProvider(presenter: presenter)
        }
    }
    
    func registerPresenter(in container: DIStoryboardContainer) {
        container.record(MainPresentationLogic.self) { (_, view: MainRenderingLogic, state: MainModuleStateRepresentable) in
            MainPresenter(view: view, state: state)
        }
    }
    
    func registerRouter(in container: DIStoryboardContainer) {
        container.record(MainRoutingLogic.self) { (_, transitionController: TransitionController) in
            MainRouter(transitionController: transitionController)
        }
    }
}
