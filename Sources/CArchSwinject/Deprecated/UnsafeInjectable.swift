//
//  UnsafeInjectable.swift
//

import CArch
import Foundation

// MARK: - UnsafeInjectable
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
@propertyWrapper
public struct UnsafeInjectable<InjectableType> {

    private var injectable: InjectableType

    public var wrappedValue: InjectableType { injectable }

    public init(_ factory: AnyDIAssemblyFactory) {
        guard
            let injectable = factory.resolver.unravel(InjectableType.self)
        else { preconditionFailure("Could not to resolve value of type \(String(describing: InjectableType.self))") }
        self.injectable = injectable
    }
    
    public init<Factory>(_ factoryType: Factory.Type) where Factory: AnyDIAssemblyFactory {
        self.init(Factory())
    }
}
