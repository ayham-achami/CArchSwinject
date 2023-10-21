//
//  InstanceStorage.swift
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
final class AlwaysNewInstanceStorageFactory: InstanceStorage {

    private var instances = [GraphIdentifier: StorageType.WeakReference<AnyObject>]()
    public var instance: Any?

    public init() {}

    public func graphResolutionCompleted() {
        instance = nil
    }

    public func instance(inGraph graph: GraphIdentifier) -> Any? {
        return instances[graph]?.wrapped
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

    /// Хранилище ссылок типа Singleton
    public static let singleton = ObjectScope(storageFactory: SingletonStorageFactory.init, description: "Singleton")

    /// Хранилище ссылок типа автоматическое освобождение
    public static let autoRelease = ObjectScope(storageFactory: AutoReleaseStorageFactory.init, description: "AutoRelease")

    /// Хранилище ссылок типа всегда новый экземпляр
    public static let alwaysNewInstance = ObjectScope(storageFactory: AlwaysNewInstanceStorageFactory.init, description: "AlwaysNewInstance")
}

// MARK: - StorageType + ObjectScope
extension StorageType {

    /// Тип ссылки для Swinject
    var scope: Swinject.ObjectScope {
        switch self {
        case .singleton:
            return .singleton
        case .autoRelease:
            return .autoRelease
        case .alwaysNewInstance:
            return .alwaysNewInstance
        }
    }
}
