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
import CArchSwinject

/// Протокол реализующий логику получения данных из слоя бизнес логики
protocol MainProvisionLogic: RootProvisionLogic {}

/// Все взаимодействия пользователя с модулем
typealias MainUserInteraction = MainRendererUserInteraction

/// Объект содержаний логику отображения данных
final class MainViewController: UIViewController {
    
    // MARK: - Injected properties
    var router: MainRoutingLogic!
    var mainRenderer: MainRenderer!
    var provider: MainProvisionLogic!
    
    /// состояние модуля `Main`
    private var state = MainModuleState()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        mainRenderer.embed(into: self)
        router.showModules([
            .init(title: "Popular", icon: UIImage(systemName: "star.square")!, type: .popular),
            .init(title: "Now Playing", icon: UIImage(systemName: "videoprojector")!, type: .nowPlaying),
            .init(title: "Upcoming", icon: UIImage(systemName: "calendar")!, type: .upcoming),
            .init(title: "Top Rated", icon: UIImage(systemName: "heart.square")!, type: .topRated)
        ])
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

#Preview(String(describing: MainModule.self)) {
    let main = MainModule.Builder().build()
    main.node.viewDidLoad()
    (main.node as? MainViewController)?
        .mainRenderer
        .viewControllers?
        .forEach { vc in
            ((vc.node as? UINavigationController)?
                .topViewController as? MoviesViewController)?
                .moviesRenderer = MoviesRenderer.preview()
    }
    return main.node
}
