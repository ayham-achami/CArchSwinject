//
//  Container+SwinjectStoryboard.swift
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

#if canImport(UIKit)
    import UIKit
#endif
import Swinject

#if os(iOS) || os(OSX) || os(tvOS)
extension Container {
    /// Adds a registration of the specified view or window controller that is configured in a storyboard.
    ///
    /// - Note: Do NOT explicitly resolve the controller registered by this method.
    ///         The controller is intended to be resolved by `SwinjectStoryboard` implicitly.
    ///
    /// - Parameters:
    ///   - controllerType: The controller type to register as a service type.
    ///                     The type is `UIViewController` in iOS, `NSViewController` or `NSWindowController` in OS X.
    ///   - name:           A registration name, which is used to differentiate from other registrations
    ///                     that have the same view or window controller type.
    ///   - initCompleted:  A closure to specify how the dependencies of the view or window controller are injected.
    ///                     It is invoked by the `Container` when the view or window controller is instantiated by `SwinjectStoryboard`.
    public func storyboardInitCompleted<C: Controller>(_ controllerType: C.Type, name: String? = nil, initCompleted: @escaping (Resolver, C) -> Void) {
        // Xcode 7.1 workaround for Issue #10. This workaround is not necessary with Xcode 7.
        // https://github.com/Swinject/Swinject/issues/10
        let factory = { (_: Resolver, controller: Controller) in controller }
        // swiftlint:disable:next force_cast
        let wrappingClosure: (Resolver, Controller) -> Void = { r, c in initCompleted(r, c as! C) }
        let option = SwinjectStoryboardOption(controllerType: controllerType)
        _register(Controller.self, factory: factory, name: name, option: option)
            .initCompleted(wrappingClosure)
    }
}
#endif

extension Container {
#if os(iOS) || os(tvOS)
    /// The typealias to UIViewController.
    public typealias Controller = UIViewController
    
#elseif os(OSX)
    /// The typealias to AnyObject, which should be actually NSViewController or NSWindowController.
    /// See the reference of NSStoryboard.instantiateInitialController method.
    public typealias Controller = Any
    
#endif
}
