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

import XCTest
import CArch
import UIKit
@testable import CArchSwinject

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
