//
//  Container+DIContainer.swift
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

// MARK: - Container + DIRegistrar
extension Container: DIRegistrar {
    
    // swiftlint:disable force_cast
    public func record<Service>(_ serviceType: Service.Type,
                                name: String,
                                inScope storage: StorageType,
                                factory: @escaping (DIResolver) -> Service) {
        guard isRegistrationNeeded(serviceType, name: name) else { return }
        register(serviceType, name: name) { resolver -> Service in
            factory(resolver as! DIResolver)
        }
        .inObjectScope(storage.scope)
    }

    public func record<Service>(_ serviceType: Service.Type,
                                inScope storage: StorageType,
                                factory: @escaping (DIResolver) -> Service) {
        guard !isRegistrationNeeded(serviceType) else { return }
        register(serviceType) { resolver -> Service in
            factory(resolver as! DIResolver)
        }
        .inObjectScope(storage.scope)
    }

    public func record<Service, Arg>(_ serviceType: Service.Type,
                                     inScope storage: StorageType,
                                     factory: @escaping (DIResolver, Arg) -> Service) {
        guard !isRegistrationNeeded(serviceType) else { return }
        register(serviceType) { (resolver, arg: Arg) -> Service in
            factory(resolver as! DIResolver, arg)
        }
        .inObjectScope(storage.scope)
    }

    public func record<Service, Arg1, Arg2>(_ serviceType: Service.Type,
                                            inScope storage: StorageType,
                                            factory: @escaping (DIResolver, Arg1, Arg2) -> Service) {
        guard !isRegistrationNeeded(serviceType) else { return }
        register(serviceType) { (resolver, arg1: Arg1, arg2: Arg2) -> Service in
            factory(resolver as! DIResolver, arg1, arg2)
        }
        .inObjectScope(storage.scope)
    }
    
    private func isRegistrationNeeded<Service>(_ serviceType: Service.Type, name: String? = nil) -> Bool {
        if !hasAnyRegistration(of: serviceType, name: name) || serviceType is CArchModuleComponent.Type {
            return true
        }
        return false
    }
    // swiftlint:enable force_cast
}

// MARK: - Container + DIResolver
extension Container: DIResolver {

    public func unravel<Service>(_ serviceType: Service.Type) -> Service? {
        synchronize().resolve(serviceType)
    }

    public func unravel<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        synchronize().resolve(serviceType, name: name)
    }

    public func unravel<Service, Arg>(_ serviceType: Service.Type, argument: Arg) -> Service? {
        synchronize().resolve(serviceType, argument: argument)
    }

    public func unravel<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments: Arg1, _ arg2: Arg2) -> Service? {
        synchronize().resolve(serviceType, arguments: arguments, arg2)
    }

    public func unravel<Service, Arg1, Arg2, Arg3>(_ serviceType: Service.Type, arguments: Arg1, _ arg2: Arg2, arg3: Arg3) -> Service? {
        synchronize().resolve(serviceType, arguments: arguments, arg2, arg3)
    }
}
