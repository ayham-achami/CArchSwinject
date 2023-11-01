//
//  SwinjectProvider.swift
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
