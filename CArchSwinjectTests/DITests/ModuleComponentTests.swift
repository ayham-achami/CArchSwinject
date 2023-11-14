//
//  ModuleComponentTests.swift
//

import CArch
@testable import CArchSwinject
import UIKit
import XCTest

class ModuleComponentTests: XCTestCase {
    
    final class Router: RootRoutingLogic {
        
        nonisolated init() {}
        
        final class Assembly: DIAssembly {
            
            func assemble(container: CArch.DIContainer) {
                container.recordComponent(Router.self) { _ in .init() }
            }
        }
    }
    
    final class Provider: RootProvisionLogic {
        
        nonisolated init() {}
        
        final class Assembly: DIAssembly {
            
            func assemble(container: CArch.DIContainer) {
                container.recordComponent(Provider.self) { _ in .init() }
            }
        }
    }
    
    final class LHSCollection: DIAssemblyCollection {
        
        let services: [DIAssembly] = [Router.Assembly(), Provider.Assembly()]
    }
    
    final class RHSCollection: DIAssemblyCollection {
        
        let services: [DIAssembly] = [Router.Assembly()]
    }
    
    let factory = LayoutAssemblyFactory()
    
    override func setUpWithError() throws {
        factory.record(LHSCollection())
    }
    
    func testModuleComponentScope() {
        let lhsRouter = factory.resolver.unravelComponent(Router.self)
        let rhsRouter = factory.resolver.unravelComponent(Router.self)
        
        XCTAssert(lhsRouter !== rhsRouter)
        
        factory.record(LHSCollection())
        
        let lhsProvider = factory.resolver.unravelComponent(Provider.self)
        let rhsProvider = factory.resolver.unravelComponent(Provider.self)
        
        XCTAssert(lhsProvider !== rhsProvider)
    }
}
