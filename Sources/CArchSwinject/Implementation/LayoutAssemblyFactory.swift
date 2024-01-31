//
//  LayoutAssemblyFactory.swift
//

import CArch
import Swinject

/// Фабрика создания и внедрение зависимости
public final class LayoutAssemblyFactory: LayoutDIAssemblyFactory {
    
    public static func set(isDebugEnabled: Bool) {
        Container.loggingFunction = isDebugEnabled ? { print($0) } : nil
    }
    
    static var provider: SwinjectProvider!
    
    public var layoutContainer: DIContainer {
        Self.provider.container
    }
    
    public var registrar: DIRegistrar {
        Self.provider.container
    }
    
    public var resolver: DIResolver {
        Self.provider.container
    }
    
    public init() {}
    
    public func assembly<Module>(_ module: Module) -> Module where Module: LayoutModuleAssembly {
        Self.provider.apply(LayoutModuleApplying(module))
        return module
    }
    
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func record<Recorder>(_ recorder: Recorder.Type) where Recorder: ServicesRecorder {
        recorder.init().records.forEach { Self.provider.apply(ServicesApplying($0)) }
    }
    
    public func record<Recorder>(_ recorder: Recorder) where Recorder: DIAssemblyCollection {
        recorder.services.forEach { Self.provider.apply(ServicesApplying($0)) }
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
