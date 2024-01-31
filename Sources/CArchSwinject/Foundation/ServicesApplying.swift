//
//  ServicesApplying.swift
//

import CArch
import Swinject

/// Вспомогательный класс для регистрации сервисов в контейнер зависимости
class ServicesApplying: Assembly {
    
    /// Модуль для сборки
    let assembly: DIAssembly

    /// Инициализации с любым модулем
    ///
    /// - Parameter anyModuleAssembly: Любой модуль
    init(_ assembly: DIAssembly) {
        self.assembly = assembly
    }

    func assemble(container: Container) {
        assembly.assemble(container: container)
    }
}
