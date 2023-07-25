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

/// Пространство имен модуля Movies
struct MoviesModule {

    /// Объект содержащий логику создания модуля `Movies`
    /// с чистой иерархии (просто ViewController)
    final class Builder: ClearHierarchyModuleBuilder {
        
        typealias InitialStateType = MoviesModuleState.InitialStateType
        
        func build(with initialState: InitialStateType) -> CArchModule {
            let module = build()
            module.initializer?.set(initialState: initialState)
            return module
        }
        
        func build() -> CArchModule {
            LayoutAssemblyFactory
                .assembly(MoviesAssembly.self)
                .unravel(MoviesViewController.self)
        }
    }
    
    /// Объект содержащий логику создания модуля `Movies`
    final class NavigationBuilder: NavigationHierarchyModuleBuilder {

        typealias InitialStateType = MoviesModuleState.InitialStateType

        func build(with initialState: InitialStateType) -> CArchModule {
            embedIntoNavigationController(Builder().build(with: initialState))
        }

        func build() -> CArchModule {
            embedIntoNavigationController(Builder().build())
        }
        
        func embedIntoNavigationController(_ module: CArchModule) -> CArchModule {
            let navigationController = UINavigationController(rootViewController: module.node)
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
    }
    
    /// Объект содержащий логику создания модуля `Movies`
    final class TabHierarchyBuilder: TabHierarchyModuleBuilder {
        
        typealias InitialStateType = MoviesModuleState.InitialState
        
        func build(with initialState: MoviesModuleState.InitialState) -> CArchModule {
            let module = NavigationBuilder().build(with: initialState)
            module.node.tabBarItem.image = initialState.icon
            module.node.tabBarItem.title = initialState.title
            return module
        }
        
        func build() -> CArchModule {
            NavigationBuilder().build()
        }
    }
}

/// Объект содержащий логику внедрения зависимости компонентов модула `Movies`
final class MoviesAssembly: LayoutModuleAssembly {
    
    required init() {
        print("MoviesModuleAssembly is beginning assembling")
    }
    
    func registerView(in container: CArch.DIContainer) {
        container.record(MoviesViewController.self) { resolver in
            let controller = MoviesViewController()
            guard
                let presenter = resolver.unravel(MoviesPresentationLogic.self,
                                                 arguments: controller as MoviesRenderingLogic,
                                                 controller as MoviesModuleStateRepresentable)
            else { preconditionFailure("Could not to build Movies module, module Presenter is nil") }
            controller.provider = resolver.unravel(MoviesProvisionLogic.self, argument: presenter as MoviesPresentationLogic)
            controller.router = resolver.unravel(MoviesRoutingLogic.self, argument: controller as TransitionController)
            controller.moviesRenderer = resolver.unravel(MoviesRenderer.self, argument: controller as MoviesUserInteraction)
            return controller
        }
    }
    
    func registerRenderers(in container: CArch.DIContainer) {
        container.record(MoviesRenderer.self) { (_, interaction: MoviesUserInteraction) in
            MoviesRenderer(interactional: interaction)
        }
    }
    
    func registerPresenter(in container: CArch.DIContainer) {
        container.record(MoviesPresentationLogic.self) { (_, view: MoviesRenderingLogic, state: MoviesModuleStateRepresentable) in
            MoviesPresenter(view: view, state: state)
        }
    }
    
    func registerProvider(in container: CArch.DIContainer) {
        container.record(MoviesProvisionLogic.self) { (resolver, presenter: MoviesPresentationLogic) in
            MoviesProvider(presenter: presenter,
                           moviesService: resolver.unravel(MoviesService.self)!)
        }
    }
    
    func registerRouter(in container: CArch.DIContainer) {
        container.record(MoviesRoutingLogic.self) { (_, transitionController: TransitionController) in
            MoviesRouter(transitionController: transitionController)
        }
    }
}
