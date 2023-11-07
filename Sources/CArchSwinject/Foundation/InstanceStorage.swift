//
//  InstanceStorage.swift
//

import CArch
import Swinject

/// Хранилище ссылок типа всегда новый экземпляр
/// всегда будет создан новый экземпляр объекта
final class FleetingStorage: InstanceStorage {
    
    public var instance: Any? {
        get { nil }
        set {} // swiftlint:disable:this unused_setter_value
    }

    public init() {}
}

/// Хранилище ссылок типа Singleton
/// сохраняет ссылку до тех пор, пока Container живой
final class SingletonStorageFactory: InstanceStorage {

    /// Ссылка на объект в контейнере
    private var strongReference: StorageType.StrongReference<AnyObject>?

    public var instance: Any? {
        get {
            strongReference?.wrapped
        }
        set {
            if let newValue = newValue as AnyObject? {
                strongReference = StorageType.StrongReference(newValue)
            } else {
                strongReference = nil
            }
        }
    }
}

/// Хранилище ссылок типа автоматическое освобождение
/// сохраняет ссылку до тех пор, пока есть сильные ссылки на экземпляр объекта.
final class AutoReleaseStorageFactory: InstanceStorage {

    /// Слабая ссылка на объект в контейнере
    private var weakReference: StorageType.WeakReference<AnyObject>?

    public var instance: Any? {
        get {
            weakReference?.wrapped
        }
        set {
            if let newValue = newValue as AnyObject? {
                weakReference = StorageType.WeakReference(newValue)
            } else {
                weakReference = nil
            }
        }
    }
}

/// Хранилище ссылок типа всегда новый экземпляр но в отличии от `AutoRelease`
/// всегда будет создан новый экземпляр объекта
/// сохраняет ссылку до тех пор, пока есть сильные ссылки на экземпляр объекта.
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
final class AlwaysNewInstanceStorageFactory: InstanceStorage {

    private var instances = [GraphIdentifier: StorageType.WeakReference<AnyObject>]()
    public var instance: Any?

    public init() {}

    public func graphResolutionCompleted() {
        instance = nil
    }

    public func instance(inGraph graph: GraphIdentifier) -> Any? {
        instances[graph]?.wrapped
    }

    public func setInstance(_ instance: Any?, inGraph graph: GraphIdentifier) {
        self.instance = instance
        if instances[graph] == nil, let instance = instance as AnyObject? {
            instances[graph] = StorageType.WeakReference(instance)
        }
    }
}

// MARK: - ObjectScope
extension ObjectScope {

    /// Хранилище ссылок типа fleeting
    public static let fleeting = ObjectScope(storageFactory: FleetingStorage.init, description: "Fleeting")
    
    /// Хранилище ссылок типа Singleton
    public static let singleton = ObjectScope(storageFactory: SingletonStorageFactory.init, description: "Singleton")

    /// Хранилище ссылок типа автоматическое освобождение
    public static let autoRelease = ObjectScope(storageFactory: AutoReleaseStorageFactory.init, description: "AutoRelease")

    /// Хранилище ссылок типа всегда новый экземпляр
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public static let alwaysNewInstance = ObjectScope(storageFactory: AlwaysNewInstanceStorageFactory.init, description: "AlwaysNewInstance")
}

// MARK: - StorageType + ObjectScope
extension StorageType {

    /// Тип ссылки для Swinject
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    var scope: Swinject.ObjectScope {
        switch self {
        case .fleeting:
            return .fleeting
        case .singleton:
            return .singleton
        case .autoRelease:
            return .autoRelease
        case .alwaysNewInstance:
            return .alwaysNewInstance
        }
    }
}
