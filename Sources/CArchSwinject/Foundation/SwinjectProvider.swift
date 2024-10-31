//
//  SwinjectProvider.swift
//

import Swinject

/// Провайдер зависимости используя `Swinject`
final class SwinjectProvider {
    
    final class ProviderBehavior: Behavior {
        
        func container<Type, Service>(_ container: Swinject.Container,
                                      didRegisterType type: Type.Type,
                                      toService entry: Swinject.ServiceEntry<Service>,
                                      withName name: String?) {
            guard Container.loggingFunction != nil else { return }
            print("[DI Provider]",
                  "Did register \(String(describing: Type.self))",
                  "Configuration: \(String(describing: name))",
                  "into container", "\n", container)
        }
    }
    
    /// Контейнер внедрения зависимостей, в котором хранятся регистрации сервисов.
    /// и извлекает зарегистрированные сервисы с введенными зависимостями.
    let container: Container
    
    /// Инициализации
    init() {
        self.container = .init(defaultObjectScope: .graph, behaviors: [ProviderBehavior()])
    }
    
    /// Применим сборщик к контейнеру
    /// - Parameter assembly: Сборщик
    func apply(_ assembly: Assembly) {
        Assembler(container: container).apply(assembly: assembly)
    }
}
