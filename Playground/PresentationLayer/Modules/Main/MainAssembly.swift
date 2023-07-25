//  The MIT License (MIT)
//
//  Copyright (c) 2019 Community Arch
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import CArch
import CArchSwinject

/// Пространство имен модуля Main
struct MainModule {

    /// Объект содержащий логику создания модуля `Main` 
    /// с чистой иерархии (просто ViewController) 
    final class Builder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MainModuleState.InitialStateType
        
        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            LayoutAssemblyFactory
                .assembly(MainAssembly.self)
                .unravel(MainViewController.self)
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `Main`
final class MainAssembly: LayoutModuleAssembly {
    
    required init() {
        print("MainModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: CArch.DIContainer) {
        container.record(MainViewController.self) { resolver in
            let controller = MainViewController()
            guard
                let presenter = resolver.unravel(MainPresentationLogic.self,
                                                 arguments: controller as MainRenderingLogic,
                                                 controller as MainModuleStateRepresentable)
            else { preconditionFailure("Could not to build Main module, module Presenter is nil") }
            controller.mainRenderer = resolver.unravel(MainRenderer.self, argument: controller as MainUserInteraction)
            controller.router = resolver.unravel(MainRoutingLogic.self, argument: controller.mainRenderer as TransitionController)
            controller.provider = resolver.unravel(MainProvisionLogic.self, argument: presenter as MainPresentationLogic)
            return controller
        }
    }
    
    func registerRenderers(in container: CArch.DIContainer) {
        container.record(MainRenderer.self) { (_, interaction: MainUserInteraction) in
            MainRenderer(interactional: interaction)
        }
    }
    
    func registerPresenter(in container: CArch.DIContainer) {
        container.record(MainPresentationLogic.self) { (_, view: MainRenderingLogic, state: MainModuleStateRepresentable) in
            MainPresenter(view: view, state: state)
        }
    }
    
    func registerProvider(in container: CArch.DIContainer) {
        container.record(MainProvisionLogic.self) { (_, presenter: MainPresentationLogic) in
            MainProvider(presenter: presenter)
        }
    }
    
    func registerRouter(in container: CArch.DIContainer) {
        container.record(MainRoutingLogic.self) { (_, transitionController: TransitionController) in
            MainRouter(transitionController: transitionController)
        }
    }
}
