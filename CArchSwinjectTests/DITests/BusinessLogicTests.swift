

import XCTest
import CArch
@testable import CArchSwinject

extension EngineConfiguration {
    
    static let testCase: Self = .init(rawValue: "TestCase")!
}

final class BusinessLogicTests: XCTestCase {

    final class Engine: BusinessLogicEngine {
        
        let name: String
        
        nonisolated init(name: String) {
            self.name = name
        }
        
        final class Assembly: DIAssembly {
            
            func assemble(container: CArch.DIContainer) {
                container.recordEngine(Engine.self, configuration: .testCase) { _ in .init(name: EngineConfiguration.testCase.rawValue) }
                container.recordEngine(Engine.self) { _ in .init(name: "") }
                
            }
        }
    }
    
    actor Agent: BusinessLogicAgent {
        
        init() {}
        
        final class Assembly: DIAssembly {
            
            func assemble(container: CArch.DIContainer) {
                container.recordAgent(Agent.self) { _ in .init() }
            }
        }
    }
    
    actor Service: BusinessLogicService {
        
        init() {}
        
        final class Assembly: DIAssembly {
            
            func assemble(container: CArch.DIContainer) {
                container.recordService(Service.self) { _ in .init() }
            }
        }
    }
    
    final class LHSCollection: DIAssemblyCollection {
        
        let services: [DIAssembly] = [Engine.Assembly(), Agent.Assembly(), Service.Assembly()]
    }
    
    final class RHSCollection: DIAssemblyCollection {
    
        let services: [DIAssembly] = [Engine.Assembly(), Agent.Assembly(), Service.Assembly()]
    }
    
    let factory = LayoutAssemblyFactory()
    
    override func setUpWithError() throws {
        factory.record(LHSCollection())
    }
    
    func testModuleComponentScope() {
        let lhsEngine = factory.resolver.unravelEngine(Engine.self, configuration: EngineConfiguration.testCase)
        let lhsAgent = factory.resolver.unravelAgent(Agent.self)
        let lhsService = factory.resolver.unravelService(Service.self)
        
        factory.record(RHSCollection())
        let rhsEngine = factory.resolver.unravelEngine(Engine.self, configuration: EngineConfiguration.testCase)
        let rhsAgent = factory.resolver.unravelAgent(Agent.self)
        let rhsService = factory.resolver.unravelService(Service.self)
        
        XCTAssert(lhsEngine === rhsEngine)
        XCTAssert(lhsAgent === rhsAgent)
        XCTAssert(lhsService === rhsService)
        
        let bhsEngine = factory.resolver.unravelEngine(Engine.self, configuration: EngineConfiguration.testCase)
        let bhsAgent = factory.resolver.unravelAgent(Agent.self)
        let bhsService = factory.resolver.unravelService(Service.self)
        
        XCTAssert(lhsEngine === bhsEngine)
        XCTAssert(lhsAgent === bhsAgent)
        XCTAssert(lhsService === bhsService)
        
        XCTAssert(bhsEngine === rhsEngine)
        XCTAssert(bhsAgent === rhsAgent)
        XCTAssert(bhsService === rhsService)
    }
}
