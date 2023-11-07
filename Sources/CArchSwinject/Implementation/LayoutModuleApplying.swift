//
//  LayoutModuleApplying.swift
//

import CArch
import Swinject

/// Вспомогательный класс для регистрации модуля в контейнер зависимости
class LayoutModuleApplying: Assembly {
    
    /// Модуль для сборки
    let moduleAssembly: LayoutModuleAssembly

    /// Инициализации с любым модулем
    ///
    /// - Parameter anyModuleAssembly: Любой модуль
    init(_ moduleAssembly: LayoutModuleAssembly) {
        self.moduleAssembly = moduleAssembly
    }

    func assemble(container: Container) {
        moduleAssembly.registerView(in: container)
        moduleAssembly.registerRenderers(in: container)
        moduleAssembly.registerPresenter(in: container)
        moduleAssembly.registerProvider(in: container)
        moduleAssembly.registerRouter(in: container)
    }
}
