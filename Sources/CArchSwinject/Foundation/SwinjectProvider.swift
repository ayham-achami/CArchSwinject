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
            print("Did register type \(String(describing: Type.self))",
                  "with: \(entry)",
                  "name: \(String(describing: name))",
                  "into container",
                  container)
        }
    }
    
    /// Контейнер внедрения зависимостей, в котором хранятся регистрации сервисов.
    /// и извлекает зарегистрированные сервисы с введенными зависимостями.
    let container: Container
    
    /// Инициализации
    init() {
        self.container = .init(behaviors: [ProviderBehavior()])
    }
    
    /// Инициализации
    /// - Parameter container: Контейнер внедрения зависимостей
    @available(*, deprecated, message: "Use init()")
    init(parentContainer: Container) {
        self.container = .init(parent: parentContainer, behaviors: [ProviderBehavior()])
    }
    
    /// Применим сборщик к контейнеру
    /// - Parameter assembly: Сборщик
    func apply(_ assembly: Assembly) {
        Assembler(container: container).apply(assembly: assembly)
    }
}
