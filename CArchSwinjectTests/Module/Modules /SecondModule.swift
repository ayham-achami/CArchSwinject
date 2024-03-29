//
//  SecondModule.swift
//

import CArch
import CArchSwinject
import Foundation
import UIKit

@SyncAlias
protocol SecondProvisionLogic: RootProvisionLogic, ErrorAsyncHandler {
    
    func obtain() async throws
}

@UIContactor
@MainActor protocol SecondRenderingLogic: RootRenderingLogic {
    
    func display()
}

protocol SecondPresentationLogic: RootPresentationLogic {
    
    func didObtain()
}

protocol SecondRoutingLogic: RootRoutingLogic {
    
    func showSecond()
}

protocol SecondRendererUserInteraction: AnyUserInteraction {
    
    func didRequestSecond()
}

final class SecondRenderer: UIView, UIRenderer, ModuleLifeCycle {
    
    weak var interaction: SecondRendererUserInteraction?
    
    init(interaction: SecondRendererUserInteraction) {
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

final class SecondView: UIViewController, SecondRenderingLogic, SecondRendererUserInteraction, ModuleLifeCycleOwner {
    
    var renderer: SecondRenderer!
    var router: SecondRoutingLogic!
    var provider: SecondProvisionLogic!
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

final class SecondRouter: SecondRoutingLogic {
    
    weak var view: SecondView?
    
    nonisolated init(view: SecondView) {
        self.view = view
    }
    
    func showSecond() {}
}

final class SecondPresenter: SecondPresentationLogic {
    
    weak var view: SecondRenderingLogic!
    
    init(view: SecondRenderingLogic) {
        self.view = view
    }
    
    func didObtain() {
        view.nonisolatedDisplay()
    }
    
    func encountered(_ error: Error) {
        print(error)
    }
}

final class SecondProvider: SecondProvisionLogic {
    
    let firstService: FirstService
    let secondService: SecondService
    let presenter: SecondPresentationLogic
    
    nonisolated init(presenter: SecondPresentationLogic,
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

final class SecondAssembly: LayoutModuleAssembly {
    
    required init() {
        print("SecondAssembly is beginning assembling")
    }
    
    func registerView(in container: DIContainer) {
        container.recordComponent(SecondView.self) { resolver in
            let view = SecondView()
            let presenter = resolver.unravelComponent(SecondPresenter.self, argument: view as SecondRenderingLogic)
            view.renderer = resolver.unravelComponent(SecondRenderer.self, argument: view as SecondRendererUserInteraction)
            view.router = resolver.unravelComponent(SecondRouter.self, argument: view)
            view.provider = resolver.unravelComponent(SecondProvider.self, argument: presenter as SecondPresentationLogic)
            return view
        }
    }
    
    func registerRenderers(in container: DIContainer) {
        container.recordComponent(SecondRenderer.self) { (_, interaction: SecondRendererUserInteraction) in
            SecondRenderer(interaction: interaction)
        }
    }
    
    func registerPresenter(in container: DIContainer) {
        container.recordComponent(SecondPresenter.self) { (_, view: SecondRenderingLogic) in
            SecondPresenter(view: view)
        }
    }
    
    func registerProvider(in container: DIContainer) {
        container.recordComponent(SecondProvider.self) { (resolver, presenter: SecondPresentationLogic) in
            SecondProvider(presenter: presenter,
                           firstService: resolver.unravelService(FirstService.self),
                           secondService: resolver.unravelService(SecondService.self))
        }
    }
    
    func registerRouter(in container: DIContainer) {
        container.recordComponent(SecondRouter.self) { (_, view: SecondView) in
            SecondRouter(view: view)
        }
    }
}

struct SecondModuleBuilder {
    
    static func build(with factory: LayoutAssemblyFactory) -> CArchModule {
        factory.record(ServicesAssemblyCollection())
        return factory.assembly(SecondAssembly.self).unravel(SecondView.self)
    }
}
