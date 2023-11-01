//
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
