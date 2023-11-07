//


import UIKit
import CArch
import Foundation

extension AlertAbility {
    
    func displayAlert(with title: String, _ message: String?) {
        print(title, String(describing: message))
    }
    
    func displayAlert(with title: String, _ message: String?, _ actions: [UIAlertAction]) {
        print(title, String(describing: message))
    }
    
    func displayAlert(with title: String, _ message: String?, _ textFieldHandler: ((UITextField) -> Void)?, _ actions: [UIAlertAction]) {
        print(title, String(describing: message))
    }
    
    func displayActionSheet(with title: String?, _ message: String?, _ actions: [UIAlertAction]) {
        print(String(describing: title), String(describing: message))
    }
}

final class FirstEngine: BusinessLogicEngine {
    
    nonisolated init() {}
}

final class SecondEngine: BusinessLogicEngine {
    
    nonisolated init() {}
}

actor FirstAgent: BusinessLogicAgent {
    
    let firstEngine: FirstEngine
    let secondEngine: SecondEngine
    
    init(firstEngine: FirstEngine, secondEngine: SecondEngine) {
        self.firstEngine = firstEngine
        self.secondEngine = secondEngine
    }
}

actor SecondAgent: BusinessLogicAgent {
    
    let firstEngine: FirstEngine
    let secondEngine: SecondEngine
    
    init(firstEngine: FirstEngine, secondEngine: SecondEngine) {
        self.firstEngine = firstEngine
        self.secondEngine = secondEngine
    }
}

actor FirstService: BusinessLogicService {
    
    let agent: FirstAgent
    
    init(agent: FirstAgent) {
        self.agent = agent
    }
}

actor SecondService: BusinessLogicService {
    
    let agent: SecondAgent
    
    init(agent: SecondAgent) {
        self.agent = agent
    }
}

final class FirstEngineAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordEngine(FirstEngine.self) { _ in
            .init()
        }
    }
}

final class SecondEngineAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordEngine(SecondEngine.self) { _ in
            .init()
        }
    }
}

final class FirstAgentAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordAgent(FirstAgent.self) { resolver in
            .init(firstEngine: resolver.unravelEngine(FirstEngine.self),
                  secondEngine: resolver.unravelEngine(SecondEngine.self))
        }
    }
}

final class SecondAgentAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordAgent(SecondAgent.self) { resolver in
            .init(firstEngine: resolver.unravelEngine(FirstEngine.self),
                  secondEngine: resolver.unravelEngine(SecondEngine.self))
        }
    }
}

final class FirstServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordService(FirstService.self) { resolver in
            .init(agent: resolver.unravelAgent(FirstAgent.self))
        }
    }
}

final class SecondServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.recordService(SecondService.self) { resolver in
            .init(agent: resolver.unravelAgent(SecondAgent.self))
        }
    }
}

struct EngineAssemblyCollection: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [FirstEngineAssembly(),
         SecondEngineAssembly()]
    }
}

struct AgentAssemblyCollection: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [FirstAgentAssembly(),
         SecondAgentAssembly()]
    }
}

struct ServicesAssemblyCollection: DIAssemblyCollection {
    
    var services: [DIAssembly] {
        [FirstServiceAssembly(),
         SecondServiceAssembly()]
    }
}
