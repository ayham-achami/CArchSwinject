//
//  LayoutModuleApplying.swift
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

import CArch
import Swinject

/// Вспомогательный класс для регистрации моудла в контейнер зависмотри
class LayoutModuleApplying: Assembly {
    
    /// Модут доя собоки
    let moduleAssembly: LayoutModuleAssembly

    /// Инициализации с любым модулем
    ///
    /// - Parameter anyModuleAssembly: Любой модуль
    init(_ moduleAssembly: LayoutModuleAssembly) {
        self.moduleAssembly = moduleAssembly
    }

    func assemble(container: Container) {
        moduleAssembly.registerView(in: container)
        moduleAssembly.registerPresenter(in: container)
        moduleAssembly.registerProvider(in: container)
        moduleAssembly.registerRouter(in: container)
    }
}
