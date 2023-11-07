

import UIKit
import CArch
import Foundation
import CArchSwinject

@SyncAlias
protocol FirstProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    func obtain() async throws
}

@UIContactor
protocol FirstRenderingLogic: RootRenderingLogic {
    
    func display()
}

protocol FirstPresentationLogic: RootPresentationLogic {
    
    func didObtain()
}

protocol FirstRoutingLogic: RootRoutingLogic {
    
    func showSecond()
}

protocol FirstRendererUserInteraction: AnyUserInteraction {
    
    func didRequestSecond()
}

final class FirstRenderer: UIView, UIRenderer, ModuleLifeCycle {
    
    weak var interaction: FirstRendererUserInteraction?
    
    init(interaction: FirstRendererUserInteraction) {
        super.init(frame: .zero)
        self.interaction = interaction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(content: String) {
        print(content)
    }
    
    func didTap() {
        interaction?.didRequestSecond()
    }
}

final class FirstView: UIViewController, FirstRenderingLogic, FirstRendererUserInteraction, ModuleLifeCycleOwner {
    
    var renderer: FirstRenderer!
    var router: FirstRoutingLogic!
    var provider: FirstProvisionLogic!
    var lifeCycle: [CArch.ModuleLifeCycle] { [renderer] }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        provider.obtain()
    }
    
    func didRequestSecond() {
        router.showSecond()
    }
    
    func display() {
        print("Has display")
    }
}

final class FirstRouter: FirstRoutingLogic {
    
    weak var view: FirstView?
    
    nonisolated init(view: FirstView) {
        self.view = view
    }
    
    func showSecond() {}
}

final class FirstPresenter: FirstPresentationLogic {
    
    weak var view: FirstRenderingLogic!
    
    init(view: FirstRenderingLogic) {
        self.view = view
    }
    
    func didObtain() {
        view.nonisolatedDisplay()
    }
    
    func encountered(_ error: Error) {
        print(error)
    }
}

final class FirstProvider: FirstProvisionLogic {
    
    let firstService: FirstService
    let secondService: SecondService
    let presenter: FirstPresentationLogic
    
    nonisolated init(presenter: FirstPresentationLogic,
                     firstService: FirstService,
                     secondService: SecondService) {
        self.presenter = presenter
        self.firstService = firstService
        self.secondService = secondService
    }
    
    func obtain() async throws {
        presenter.didObtain()
    }
    
    func encountered(_ error: Error) {
        presenter.encountered(error)
    }
}

final class FirstAssembly: LayoutModuleAssembly {
    
    required init() {
        print("FirstAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.recordComponent(FirstView.self) { resolver in
            let view = FirstView()
            let presenter = resolver.unravelComponent(FirstPresenter.self, argument: view as FirstRenderingLogic)
            view.renderer = resolver.unravelComponent(FirstRenderer.self, argument: view as FirstRendererUserInteraction)
            view.router = resolver.unravelComponent(FirstRouter.self, argument: view)
            view.provider = resolver.unravelComponent(FirstProvider.self, argument: presenter as FirstPresentationLogic)
            return view
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.recordComponent(FirstRenderer.self) { (_, interaction: FirstRendererUserInteraction) in
            FirstRenderer(interaction: interaction)
        }
    }
    
    func registerPresenter(in container: DIContainer) {
        container.recordComponent(FirstPresenter.self) { (_, view: FirstRenderingLogic) in
            FirstPresenter(view: view)
        }
    }
    
    func registerProvider(in container: DIContainer) {
        container.recordComponent(FirstProvider.self) { (resolver, presenter: FirstPresentationLogic) in
            FirstProvider(presenter: presenter,
                          firstService: resolver.unravelService(FirstService.self),
                          secondService: resolver.unravelService(SecondService.self))
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.recordComponent(FirstRouter.self) { (_, view: FirstView) in
            FirstRouter(view: view)
        }
    }
}

struct FirstModuleBuilder {
    
    static func build(with factory: LayoutAssemblyFactory) -> CArchModule {
        factory.record(ServicesAssemblyCollection())
        return factory.assembly(FirstAssembly.self).unravel(FirstView.self)
    }
}
