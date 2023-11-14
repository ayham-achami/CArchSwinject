//
//  ModuleAssemblyTests.swift
//

import CArch
@testable import CArchSwinject
import XCTest

final class ModuleAssemblyTests: XCTestCase {
    
    var firstModule: CArchModule!
    var secondModule: CArchModule!
    
    override func setUpWithError() throws {
        let factory = LayoutAssemblyFactory()
        factory.record(EngineAssemblyCollection())
        factory.record(AgentAssemblyCollection())
        firstModule = FirstModuleBuilder.build(with: factory)
        secondModule = SecondModuleBuilder.build(with: factory)
    }
    
    // swiftlint:disable:next function_body_length
    func testFirstModule() {
        let view = firstModule as? FirstView
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(view?.router)
        XCTAssertNotNil(view?.provider)
        XCTAssertNotNil(view?.renderer)
        
        let provider = view?.provider as? FirstProvider
        XCTAssertNotNil(provider?.presenter)
        
        let presenter = provider?.presenter as? FirstPresenter
        XCTAssertNotNil(presenter?.view)
        
        let factory = LayoutAssemblyFactory()
        let rhsFirstModule = FirstModuleBuilder.build(with: factory)
        
        let rhsView = rhsFirstModule as? FirstView
        
        XCTAssertNotNil(rhsView)
        XCTAssertNotNil(rhsView?.router)
        XCTAssertNotNil(rhsView?.provider)
        XCTAssertNotNil(rhsView?.renderer)
        
        let rhsProvider = rhsView?.provider as? FirstProvider
        XCTAssertNotNil(rhsProvider?.presenter)
        
        let rhsPresenter = rhsProvider?.presenter as? FirstPresenter
        XCTAssertNotNil(rhsPresenter?.view)
        
        XCTAssertTrue(view !== rhsView)
        XCTAssertTrue(view?.provider !== rhsView?.provider)
        XCTAssertTrue(view?.router !== rhsView?.router)
        XCTAssertTrue(view?.renderer !== rhsView?.renderer)
        XCTAssertTrue(provider?.presenter !== rhsProvider?.presenter)
        XCTAssertTrue(presenter?.view !== rhsPresenter?.view)
        
        let firstService = provider?.firstService
        let secondService = provider?.secondService
        
        XCTAssertNotNil(firstService)
        XCTAssertNotNil(secondService)
        
        let rhsFirstService = rhsProvider?.firstService
        let rhsSecondService = rhsProvider?.secondService
        
        XCTAssertNotNil(rhsFirstService)
        XCTAssertNotNil(rhsSecondService)
        
        XCTAssertTrue(firstService === rhsFirstService)
        XCTAssertTrue(secondService === rhsSecondService)
        
        let firstAgent = firstService?.agent
        let secondAgent = secondService?.agent
        
        XCTAssertNotNil(firstAgent)
        XCTAssertNotNil(secondAgent)
        
        let rhsFirstAgent = rhsFirstService?.agent
        let rhsSecondAgent = rhsSecondService?.agent
        
        XCTAssertNotNil(rhsFirstAgent)
        XCTAssertNotNil(rhsSecondAgent)
        
        XCTAssertTrue(firstAgent === rhsFirstAgent)
        XCTAssertTrue(secondAgent === rhsSecondAgent)
        
        let firstAgentFirstEngine = firstService?.agent.firstEngine
        let secondAgentFirstEngine = secondService?.agent.firstEngine
        
        XCTAssertNotNil(firstAgentFirstEngine)
        XCTAssertNotNil(secondAgentFirstEngine)
        
        let rhsFirstAgentFirstEngine = rhsFirstService?.agent.firstEngine
        let rhsSecondAgentFirstEngine = rhsSecondService?.agent.firstEngine
        
        XCTAssertNotNil(rhsFirstAgentFirstEngine)
        XCTAssertNotNil(rhsSecondAgentFirstEngine)
        
        XCTAssertTrue(firstAgentFirstEngine === secondAgentFirstEngine)
        XCTAssertTrue(firstAgentFirstEngine === rhsFirstAgentFirstEngine)
        XCTAssertTrue(firstAgentFirstEngine === rhsSecondAgentFirstEngine)
        
        XCTAssertTrue(secondAgentFirstEngine === rhsFirstAgentFirstEngine)
        XCTAssertTrue(secondAgentFirstEngine === rhsSecondAgentFirstEngine)
        
        XCTAssertTrue(rhsFirstAgentFirstEngine === rhsSecondAgentFirstEngine)
        
        let firstAgentSecondEngine = firstService?.agent.secondEngine
        let secondAgentSecondEngine = secondService?.agent.secondEngine
        
        XCTAssertNotNil(firstAgentSecondEngine)
        XCTAssertNotNil(secondAgentSecondEngine)
        
        let rhsFirstAgentSecondEngine = rhsFirstService?.agent.secondEngine
        let rhsSecondAgentSecondEngine = rhsSecondService?.agent.secondEngine
        
        XCTAssertNotNil(rhsFirstAgentSecondEngine)
        XCTAssertNotNil(rhsSecondAgentSecondEngine)
        
        XCTAssertTrue(firstAgentSecondEngine === secondAgentSecondEngine)
        XCTAssertTrue(firstAgentSecondEngine === rhsFirstAgentSecondEngine)
        XCTAssertTrue(firstAgentSecondEngine === rhsSecondAgentSecondEngine)
        
        XCTAssertTrue(secondAgentSecondEngine === rhsFirstAgentSecondEngine)
        XCTAssertTrue(secondAgentSecondEngine === rhsSecondAgentSecondEngine)
        
        XCTAssertTrue(rhsFirstAgentSecondEngine === rhsSecondAgentSecondEngine)
    }
    
    // swiftlint:disable:next function_body_length
    func testSecondModule() {
        let view = secondModule as? SecondView
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(view?.router)
        XCTAssertNotNil(view?.provider)
        XCTAssertNotNil(view?.renderer)
        
        let provider = view?.provider as? SecondProvider
        XCTAssertNotNil(provider?.presenter)
        
        let presenter = provider?.presenter as? SecondPresenter
        XCTAssertNotNil(presenter?.view)
        
        let factory = LayoutAssemblyFactory()
        let rhsFirstModule = SecondModuleBuilder.build(with: factory)
        
        let rhsView = rhsFirstModule as? SecondView
        
        XCTAssertNotNil(rhsView)
        XCTAssertNotNil(rhsView?.router)
        XCTAssertNotNil(rhsView?.provider)
        XCTAssertNotNil(rhsView?.renderer)
        
        let rhsProvider = rhsView?.provider as? SecondProvider
        XCTAssertNotNil(rhsProvider?.presenter)
        
        let rhsPresenter = rhsProvider?.presenter as? SecondPresenter
        XCTAssertNotNil(rhsPresenter?.view)
        
        XCTAssertTrue(view !== rhsView)
        XCTAssertTrue(view?.provider !== rhsView?.provider)
        XCTAssertTrue(view?.router !== rhsView?.router)
        XCTAssertTrue(view?.renderer !== rhsView?.renderer)
        XCTAssertTrue(provider?.presenter !== rhsProvider?.presenter)
        XCTAssertTrue(presenter?.view !== rhsPresenter?.view)
        
        let firstService = provider?.firstService
        let secondService = provider?.secondService
        
        XCTAssertNotNil(firstService)
        XCTAssertNotNil(secondService)
        
        let rhsFirstService = rhsProvider?.firstService
        let rhsSecondService = rhsProvider?.secondService
        
        XCTAssertNotNil(rhsFirstService)
        XCTAssertNotNil(rhsSecondService)
        
        XCTAssertTrue(firstService === rhsFirstService)
        XCTAssertTrue(secondService === rhsSecondService)
        
        let firstAgent = firstService?.agent
        let secondAgent = secondService?.agent
        
        XCTAssertNotNil(firstAgent)
        XCTAssertNotNil(secondAgent)
        
        let rhsFirstAgent = rhsFirstService?.agent
        let rhsSecondAgent = rhsSecondService?.agent
        
        XCTAssertNotNil(rhsFirstAgent)
        XCTAssertNotNil(rhsSecondAgent)
        
        XCTAssertTrue(firstAgent === rhsFirstAgent)
        XCTAssertTrue(secondAgent === rhsSecondAgent)
        
        let firstAgentFirstEngine = firstService?.agent.firstEngine
        let secondAgentFirstEngine = secondService?.agent.firstEngine
        
        XCTAssertNotNil(firstAgentFirstEngine)
        XCTAssertNotNil(secondAgentFirstEngine)
        
        let rhsFirstAgentFirstEngine = rhsFirstService?.agent.firstEngine
        let rhsSecondAgentFirstEngine = rhsSecondService?.agent.firstEngine
        
        XCTAssertNotNil(rhsFirstAgentFirstEngine)
        XCTAssertNotNil(rhsSecondAgentFirstEngine)
        
        XCTAssertTrue(firstAgentFirstEngine === secondAgentFirstEngine)
        XCTAssertTrue(firstAgentFirstEngine === rhsFirstAgentFirstEngine)
        XCTAssertTrue(firstAgentFirstEngine === rhsSecondAgentFirstEngine)
        
        XCTAssertTrue(secondAgentFirstEngine === rhsFirstAgentFirstEngine)
        XCTAssertTrue(secondAgentFirstEngine === rhsSecondAgentFirstEngine)
        
        XCTAssertTrue(rhsFirstAgentFirstEngine === rhsSecondAgentFirstEngine)
        
        let firstAgentSecondEngine = firstService?.agent.secondEngine
        let secondAgentSecondEngine = secondService?.agent.secondEngine
        
        XCTAssertNotNil(firstAgentSecondEngine)
        XCTAssertNotNil(secondAgentSecondEngine)
        
        let rhsFirstAgentSecondEngine = rhsFirstService?.agent.secondEngine
        let rhsSecondAgentSecondEngine = rhsSecondService?.agent.secondEngine
        
        XCTAssertNotNil(rhsFirstAgentSecondEngine)
        XCTAssertNotNil(rhsSecondAgentSecondEngine)
        
        XCTAssertTrue(firstAgentSecondEngine === secondAgentSecondEngine)
        XCTAssertTrue(firstAgentSecondEngine === rhsFirstAgentSecondEngine)
        XCTAssertTrue(firstAgentSecondEngine === rhsSecondAgentSecondEngine)
        
        XCTAssertTrue(secondAgentSecondEngine === rhsFirstAgentSecondEngine)
        XCTAssertTrue(secondAgentSecondEngine === rhsSecondAgentSecondEngine)
        
        XCTAssertTrue(rhsFirstAgentSecondEngine === rhsSecondAgentSecondEngine)
    }
}
