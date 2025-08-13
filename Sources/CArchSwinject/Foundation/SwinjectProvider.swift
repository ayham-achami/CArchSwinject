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
    
    private let originalContainer: Container
    
    /// Контейнер внедрения зависимостей, в котором хранятся регистрации сервисов.
    /// и извлекает зарегистрированные сервисы с введенными зависимостями.
    /// Для тредобезопасности (запись/регистрация и чтение/поиск из разных тредов) контейнер сделан синхронным.
    let container: Container
    
    /// Инициализации
    init() {
        self.originalContainer = .init(defaultObjectScope: .graph, behaviors: [ProviderBehavior()])
        self.container = self.originalContainer.synchronize() as! Container // swiftlint:disable:this force_cast
    }
    
    /// Применим сборщик к контейнеру
    /// - Parameter assembly: Сборщик
    func apply(_ assembly: Assembly) {
        Assembler(container: container).apply(assembly: assembly)
    }
}
