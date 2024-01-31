//
//  Container+DIContainer.swift
//

import CArch
import Swinject

// MARK: - Resolver + DIResolver
private extension Resolver {

    var project: DIResolver {
        self as! DIContainer // swiftlint:disable:this force_cast
    }
}

// MARK: - Container + Registration check
private extension Container {
    
    func registerIfNeeded<Object>(_: Object.Type, name: String? = nil, factory: @escaping (Resolver) -> Object) -> ServiceEntry<Object>? {
        guard
            !hasAnyRegistration(of: Object.self, name: name)
        else { return nil }
        return register(Object.self, name: name, factory: factory)
    }
}

// MARK: - Container + BusinessLogicRegistrar
extension Container: BusinessLogicRegistrar {
    
    public func recordAgent<Agent>(_: Agent.Type,
                                   factory: @escaping (CArch.DIResolver) -> Agent) where Agent: CArch.BusinessLogicAgent {
        registerIfNeeded(Agent.self) { factory($0.project) }?.inObjectScope(.autoRelease)
    }
    
    public func recordService<Service>(_: Service.Type,
                                       factory: @escaping (CArch.DIResolver) -> Service) where Service: CArch.BusinessLogicService {
        registerIfNeeded(Service.self) { factory($0.project) }?.inObjectScope(.autoRelease)
    }
    
    public func recordEngine<Engine>(_: Engine.Type,
                                     factory: @escaping (CArch.DIResolver) -> Engine) where Engine: CArch.BusinessLogicEngine {
        registerIfNeeded(Engine.self) { factory($0.project) }?.inObjectScope(.autoRelease)
    }
    
    public func recordEngine<Engine>(_: Engine.Type,
                                     configuration: CArch.EngineConfiguration,
                                     factory: @escaping (CArch.DIResolver) -> Engine) where Engine: CArch.BusinessLogicEngine {
        registerIfNeeded(Engine.self, name: configuration.rawValue) { factory($0.project) }?.inObjectScope(.autoRelease)
    }
    
    public func recordPool<Pool>(_: Pool.Type,
                                 factory: @escaping (CArch.DIResolver) -> Pool) where Pool: CArch.BusinessLogicServicePool {
        registerIfNeeded(Pool.self) { factory($0.project) }?.inObjectScope(.autoRelease)
    }
    
    public func recordSingleton<Singleton>(_: Singleton.Type,
                                           factory: @escaping (CArch.DIResolver) -> Singleton) where Singleton: CArch.BusinessLogicSingleton {
        registerIfNeeded(Singleton.self) { factory($0.project) }?.inObjectScope(.singleton)
    }
}

// MARK: - Container + ModuleComponentRegistrar
extension Container: ModuleComponentRegistrar {
    
    public func recordComponent<Component>(_: Component.Type, factory: @escaping (CArch.DIResolver) -> Component) where Component: CArch.CArchModuleComponent {
        register(Component.self) { factory($0.project) }.inObjectScope(.fleeting)
    }
    
    public func recordComponent<Component, Argument>(_: Component.Type,
                                                     factory: @escaping (DIResolver, Argument) -> Component) where Component: CArchModuleComponent {
        register(Component.self) { (resolver, arg: Argument) -> Component in
            factory(resolver.project, arg)
        }.inObjectScope(.fleeting)
    }
    
    public func recordComponent<Component, Argument1, Argument2>(_: Component.Type,
                                                                 factory: @escaping (DIResolver, Argument1, Argument2) -> Component) where Component: CArchModuleComponent {
        register(Component.self) { (resolver, arg1: Argument1, arg2: Argument2) -> Component in
            factory(resolver.project, arg1, arg2)
        }.inObjectScope(.fleeting)
    }
    
    public func recordComponent<Component, Argument1, Argument2, Argument3>(_: Component.Type,
                                                                            factory: @escaping (DIResolver, Argument1, Argument2, Argument3) -> Component) where Component: CArchModuleComponent {
        register(Component.self) { (resolver, arg1: Argument1, arg2: Argument2, arg3: Argument3) -> Component in
            factory(resolver.project, arg1, arg2, arg3)
        }.inObjectScope(.fleeting)
    }
}

// MARK: - Container + DIRegistrar
extension Container: DIRegistrar {
    
    public func record<Service>(some _: Service.Type, inScope storage: StorageType, configuration: (any InjectConfiguration)?, factory: @escaping (DIResolver) -> Service) {
        let entry = register(Service.self, name: configuration?.rawValue) { resolver -> Service in
            factory(resolver.project)
        }
        switch storage {
        case .fleeting:
            entry.inObjectScope(.fleeting)
        case .singleton:
            entry.inObjectScope(.singleton)
        case .autoRelease:
            entry.inObjectScope(.autoRelease)
        case .alwaysNewInstance:
            preconditionFailure("Try to use deprecated storage alwaysNewInstance")
        }
    }
    
    @available(*, deprecated, renamed: "record(some:inScope:configuration:factory:)")
    public func record<Service>(_: Service.Type,
                                inScope storage: CArch.StorageType,
                                configuration: (any CArch.InjectConfiguration)?,
                                factory: @escaping (CArch.DIResolver) -> Service) {
        let entry = register(Service.self, name: configuration?.rawValue) { resolver -> Service in
            factory(resolver.project)
        }
        switch storage {
        case .fleeting:
            entry.inObjectScope(.fleeting)
        case .singleton:
            entry.inObjectScope(.singleton)
        case .autoRelease:
            entry.inObjectScope(.autoRelease)
        case .alwaysNewInstance:
            preconditionFailure("Try to use deprecated storage alwaysNewInstance")
        }
    }
    
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func record<Service>(_ serviceType: Service.Type,
                                name: String,
                                inScope storage: StorageType,
                                factory: @escaping (DIResolver) -> Service) {
        guard !hasAnyRegistration(of: serviceType, name: name) else { return }
        register(serviceType, name: name) { resolver -> Service in
            factory(resolver.project)
        }.inObjectScope(storage.scope)
    }

    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func record<Service>(_ serviceType: Service.Type,
                                inScope storage: StorageType,
                                factory: @escaping (DIResolver) -> Service) {
        guard !hasAnyRegistration(of: serviceType) else { return }
        register(serviceType) { resolver -> Service in
            factory(resolver.project)
        }.inObjectScope(storage.scope)
    }

    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func record<Service, Arg>(_ serviceType: Service.Type,
                                     inScope storage: StorageType,
                                     factory: @escaping (DIResolver, Arg) -> Service) {
        guard !hasAnyRegistration(of: serviceType) else { return }
        register(serviceType) { (resolver, arg: Arg) -> Service in
            factory(resolver.project, arg)
        }.inObjectScope(storage.scope)
    }

    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func record<Service, Arg1, Arg2>(_ serviceType: Service.Type,
                                            inScope storage: StorageType,
                                            factory: @escaping (DIResolver, Arg1, Arg2) -> Service) {
        guard !hasAnyRegistration(of: serviceType) else { return }
        register(serviceType) { (resolver, arg1: Arg1, arg2: Arg2) -> Service in
            factory(resolver.project, arg1, arg2)
        }.inObjectScope(storage.scope)
    }
}

// MARK: - Container + BusinessLogicResolver
extension Container: BusinessLogicResolver {

    public func unravelAgent<Agent>(_: Agent.Type) -> Agent where Agent: CArch.BusinessLogicAgent {
        synchronize().resolve(Lazy<Agent>.self)!.instance
    }
    
    public func unravelService<Service>(_: Service.Type) -> Service where Service: CArch.BusinessLogicService {
        synchronize().resolve(Lazy<Service>.self)!.instance
    }
    
    public func unravelEngine<Engine>(_: Engine.Type) -> Engine where Engine: CArch.BusinessLogicEngine {
        synchronize().resolve(Lazy<Engine>.self)!.instance
    }
    
    public func unravelEngine<Engine>(_: Engine.Type, configuration: CArch.EngineConfiguration) -> Engine where Engine: CArch.BusinessLogicEngine {
        synchronize().resolve(Lazy<Engine>.self, name: configuration.rawValue)!.instance
    }
    
    public func unravelPool<Pool>(_: Pool.Type) -> Pool where Pool: CArch.BusinessLogicServicePool {
        synchronize().resolve(Lazy<Pool>.self)!.instance
    }
    
    public func unravelSingleton<Singleton>(_: Singleton.Type) -> Singleton where Singleton: CArch.BusinessLogicSingleton {
        synchronize().resolve(Lazy<Singleton>.self)!.instance
    }
}

// MARK: - Container + ModuleComponentResolver
extension Container: ModuleComponentResolver {
    
    public func unravelModule<Module>(_: Module.Type) -> Module where Module: CArchModule {
        synchronize().resolve(Provider<Module>.self)!.instance
    }
    
    public func unravelComponent<Component>(_: Component.Type) -> Component where Component: CArch.CArchModuleComponent {
        synchronize().resolve(Provider<Component>.self)!.instance
    }
    
    public func unravelComponent<Component, Argument>(_: Component.Type,
                                                      argument: Argument) -> Component where Component: CArch.CArchModuleComponent {
        synchronize().resolve(Provider<Component>.self, argument: argument)!.instance
    }
    
    public func unravelComponent<Component, Argument1, Argument2>(_: Component.Type,
                                                                  argument1: Argument1,
                                                                  argument2: Argument2) -> Component where Component: CArch.CArchModuleComponent {
        synchronize().resolve(Provider<Component>.self, arguments: argument1, argument2)!.instance
    }
    
    public func unravelComponent<Component, Argument1, Argument2, Argument3>(_: Component.Type,
                                                                             argument1: Argument1,
                                                                             argument2: Argument2,
                                                                             argument3: Argument3) -> Component where Component: CArch.CArchModuleComponent {
        synchronize().resolve(Provider<Component>.self, arguments: argument1, argument2, argument3)!.instance
    }
}

// MARK: - Container + DIResolver
extension Container: DIResolver {
    
    public func unravel<Service>(some _: Service.Type) -> Service {
        synchronize().resolve(Service.self)!
    }
    
    public func unravel<Service>(some _: Service.Type, configuration: any InjectConfiguration) -> Service {
        synchronize().resolve(Service.self, name: configuration.rawValue)!
    }

    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func unravel<Service>(_ serviceType: Service.Type) -> Service? {
        synchronize().resolve(serviceType)
    }
    
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func unravel<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        synchronize().resolve(serviceType, name: name)
    }

    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func unravel<Service, Arg>(_ serviceType: Service.Type, argument: Arg) -> Service? {
        synchronize().resolve(serviceType, argument: argument)
    }
    
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func unravel<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments: Arg1, _ arg2: Arg2) -> Service? {
        synchronize().resolve(serviceType, arguments: arguments, arg2)
    }

    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func unravel<Service, Arg1, Arg2, Arg3>(_ serviceType: Service.Type, arguments: Arg1, _ arg2: Arg2, arg3: Arg3) -> Service? {
        synchronize().resolve(serviceType, arguments: arguments, arg2, arg3)
    }
}
