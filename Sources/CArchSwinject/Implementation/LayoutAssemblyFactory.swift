//
//  LayoutAssemblyFactory.swift
//

import CArch
import Foundation
import Swinject

/// Фабрика создания и внедрение зависимости
public final class LayoutAssemblyFactory: LayoutDIAssemblyFactory {
    
    public static func set(isDebugEnabled: Bool) {
        Container.loggingFunction = isDebugEnabled ? { print($0) } : nil
    }
    
    static private let provider = Atomic<SwinjectProvider>(.init())
    
    public var layoutContainer: DIContainer {
        Self.provider.read { $0.container }
    }
    
    public var registrar: DIRegistrar {
        Self.provider.read { $0.container }
    }
    
    public var resolver: DIResolver {
        Self.provider.read { $0.container }
    }
    
    public init() {}
    
    public func assembly<Module>(_ module: Module) -> Module where Module: LayoutModuleAssembly {
        Self.provider.read { $0.apply(LayoutModuleApplying(module)) }
        return module
    }
    
    public func record<Recorder>(_ recorder: Recorder) where Recorder: DIAssemblyCollection {
        Self.provider.read { provider in
            recorder.services.forEach { service in
                provider.apply(ServicesApplying(service))
            }
        }
    }
}

// MARK: - LayoutAssemblyFactory + Resolver
extension LayoutAssemblyFactory {
    
    /// Объект получение модуля из контейнера зависимости
    public struct Resolver<Assembly> where Assembly: AnyObject, Assembly: LayoutModuleAssembly {
        
        public typealias Weak = StorageType.WeakReference<Assembly>
        
        /// Слабая ссылка на сборщик модуля
        private let reference: Weak
        /// Фабрика зависимости
        private let factory: LayoutAssemblyFactory
        
        /// Инициализация
        /// - Parameter factory: Фабрика зависимости
        public init(factory: LayoutAssemblyFactory) {
            self.factory = factory
            self.reference = .init(factory.assembly(Assembly()))
        }
        
        /// Получение объекта из контейнера зависимости
        /// - Parameter moduleType: Тип модуля
        /// - Returns: Объекта из контейнера зависимости
        public func unravel<Module>(_: Module.Type) -> Module where Module: CArchModule {
            factory.resolver.unravelModule(Module.self)
        }
    }
    
    /// Собрать модуля
    /// - Parameter type: Тип модуля
    /// - Returns: Объект получение модуля из контейнера зависимости
    public static func assembly<Module>(_: Module.Type) -> Resolver<Module> {
        .init(factory: .init())
    }
    
    /// Собрать модуля
    /// - Parameter type: Тип модуля
    /// - Returns: Объект получение модуля из контейнера зависимости
    public func assembly<Module>(_: Module.Type) -> Resolver<Module> {
        .init(factory: self)
    }
}

// MARK: - LayoutAssemblyFactory + Atomic
extension LayoutAssemblyFactory {
    
    final class Atomic<T>: @unchecked Sendable {
        
        private var value: T
        private let unfairLock: os_unfair_lock_t
        
        /// Инициализация
        /// - Parameter value: Атомарное значение
        init(_ value: T) {
            self.value = value
            self.unfairLock = .allocate(capacity: 1)
            self.unfairLock.initialize(to: os_unfair_lock())
        }
        
        deinit {
            unfairLock.deinitialize(count: 1)
            unfairLock.deallocate()
        }
        
        /// Синхронно прочитать или преобразовать содержащееся значение.
        /// - Parameter closure: Замыкание
        /// - Returns: Нужное значение
        func read<U>(_ closure: @Sendable (T) throws -> U) rethrows -> U {
            try around { try closure(self.value) }
        }
        
        /// Синхронно изменить защищенное значение.
        /// - Parameter closure: Замыкание
        /// - Returns: Нужное значение
        @discardableResult
        func write<U>(_ closure: @Sendable (inout T) throws -> U) rethrows -> U {
            try around { try closure(&self.value) }
        }
        
        /// Выполняет замыкание, возвращая значение и синхронизировать обращение.
        /// - Parameter closure: Замыкание
        /// - Returns: Нужное значение
        private func around<U>(_ closure: @Sendable () throws -> U) rethrows -> U {
            lock()
            defer { unlock() }
            return try closure()
        }
        
        /// Выполняет замыкание, возвращая значение и синхронизировать обращение.
        /// - Parameter closure: Замыкание
        /// - Returns: Нужное значение
        private func around<U>(_ closure: @Sendable () async throws -> U) async rethrows -> U {
            lock()
            defer { unlock() }
            return try await closure()
        }
        
        /// Блокировать доступ к значению
        private func lock() {
            os_unfair_lock_lock(unfairLock)
        }
        
        /// Разблокировать доступ к значению
        private func unlock() {
            os_unfair_lock_unlock(unfairLock)
        }
    }
}
