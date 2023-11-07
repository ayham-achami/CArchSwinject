//
//  StoryboardModuleApplying.swift
//

import CArch
import Swinject

/// Вспомогательный класс для регистрации модуля в контейнер зависимости
@available(*, deprecated, message: "Use LayoutModuleApplying")
class StoryboardModuleApplying: Assembly {
    
    /// Модуль для сборки
    let moduleAssembly: StoryboardModuleAssembly

    /// Инициализации с любым модулем
    ///
    /// - Parameter anyModuleAssembly: Любой модуль
    init(_ moduleAssembly: StoryboardModuleAssembly) {
        self.moduleAssembly = moduleAssembly
    }

    func assemble(container: Container) {
        moduleAssembly.registerView(in: container)
        moduleAssembly.registerPresenter(in: container)
        moduleAssembly.registerProvider(in: container)
        moduleAssembly.registerRouter(in: container)
    }
}
