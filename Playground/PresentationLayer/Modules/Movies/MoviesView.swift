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

import UIKit
import CArch

/// Протокол реализующий логику получения данных из слоя бизнес логики
protocol MoviesProvisionLogic: RootProvisionLogic {
    
    func obtainMovies(of type: MoviesModuleState.MoviesType, at page: Int)
}

/// Все взаимодействия пользователя с модулем
typealias MoviesUserInteraction = MoviesRendererUserInteraction

/// Объект содержаний логику отображения данных
class MoviesViewController: UIViewController, ModuleLifeCycleOwner {

    private let moduleReference = assembly(MoviesAssembly.self)

    var moviesRenderer: MoviesRenderer!
    var provider: MoviesProvisionLogic!
    var router: MoviesRoutingLogic!

    var lifeCycle: [ModuleLifeCycle] { [moviesRenderer] }

    private var state = MoviesModuleState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = state.initial.title
        
        moduleDidLoad()
        
        view.addSubview(moviesRenderer)
        NSLayoutConstraint.activate([
            moviesRenderer.topAnchor.constraint(equalTo: view.topAnchor),
            moviesRenderer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moviesRenderer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesRenderer.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        provider.obtainMovies(of: state.initial.type, at: state.page)
    }
}

// MARK: - AnyModuleInitializer
extension MoviesViewController: AnyModuleInitializer {

    func set<StateType>(initialState: StateType) where StateType: ModuleInitialState {
        state.initialState = initialState.is(MoviesModuleState.InitialStateType.self)
    }
}

// MARK: - Movies + Finalizer
extension MoviesViewController: AnyModuleFinalizer {

    func didFinalization<StateType>(with finalState: StateType) where StateType: ModuleFinalState {}
}

// MARK: - MoviesModuleStateRepresentable
extension MoviesViewController: MoviesModuleStateRepresentable {

    var readOnly: MoviesModuleReadOnlyState {
        state
    }
}

// MARK: - MoviesRenderingLogic
extension MoviesViewController: MoviesRenderingLogic {
    
    func display(_ movies: [MovieCell.ModelType]) {
        moviesRenderer.set(content: movies)
        state.page += 1
    }
}

// MARK: - MoviesUserInteraction
extension MoviesViewController: MoviesUserInteraction {
    
    func didRequestMoreMovies() {
        provider.obtainMovies(of: state.initial.type, at: state.page)
    }
}

#Preview(String(describing: MoviesModule.self), traits: .defaultLayout) {
    let state = MoviesModuleState.InitialState(title: "Title",
                                               icon: UIImage(systemName: "star.square.fill")!,
                                               type: .popular)
    let movies = MoviesModule.TabHierarchyBuilder().build(with: state)
    ((movies.node as? UINavigationController)?
        .topViewController as? MoviesViewController)?
        .moviesRenderer = MoviesRenderer.preview()
    return movies.node
    
}
