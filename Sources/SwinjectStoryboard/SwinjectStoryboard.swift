//
//  SwinjectStoryboard.swift
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

#if os(iOS) || os(tvOS)
import UIKit
/// The `SwinjectStoryboard` provides the features to inject dependencies of view/window controllers in a storyboard.
///
/// To specify a registration name of a view/window controller registered to the `Container` as a service type,
/// add a user defined runtime attribute with the following settings:
///
/// - Key Path: `swinjectRegistrationName`
/// - Type: String
/// - Value: Registration name to the `Container`
///
/// in User Defined Runtime Attributes section on Indentity Inspector pane.
/// If no name is supplied to the registration, no runtime attribute should be specified.
@objcMembers
public class SwinjectStoryboard: _SwinjectStoryboardBase, SwinjectStoryboardProtocol {
    /// A shared container used by SwinjectStoryboard instances that are instantiated without specific containers.
    ///
    /// Typical usecases of this property are:
    /// - Implicit instantiation of UIWindow and its root view controller from "Main" storyboard.
    /// - Storyboard references to transit from a storyboard to another.
    public static var defaultContainer = Container()
    
    // Boxing to workaround a runtime error [Xcode 7.1.1 and Xcode 7.2 beta 4]
    // If container property is Resolver type and a Resolver instance is assigned to the property,
    // the program crashes by EXC_BAD_ACCESS, which looks a bug of Swift.
    internal var container: Box<Resolver>!

    private override init() {
        super.init()
    }

    /// Creates the new instance of `SwinjectStoryboard`. This method is used instead of an initializer.
    ///
    /// - Parameters:
    ///   - name:      The name of the storyboard resource file without the filename extension.
    ///   - storyboardBundleOrNil:    The bundle containing the storyboard file and its resources. Specify nil to use the main bundle.
    ///
    /// - Note:
    ///                The shared singleton container `SwinjectStoryboard.defaultContainer` is used as the container.
    ///
    /// - Returns: The new instance of `SwinjectStoryboard`.
    public class func create(name: String,
                             bundle storyboardBundleOrNil: Bundle?) -> SwinjectStoryboard {
        SwinjectStoryboard.create(name: name, bundle: storyboardBundleOrNil, container: SwinjectStoryboard.defaultContainer)
    }

    /// Creates the new instance of `SwinjectStoryboard`. This method is used instead of an initializer.
    ///
    /// - Parameters:
    ///   - name:      The name of the storyboard resource file without the filename extension.
    ///   - storyboardBundleOrNil:    The bundle containing the storyboard file and its resources. Specify nil to use the main bundle.
    ///   - container: The container with registrations of the view/window controllers in the storyboard and their dependencies.
    ///
    /// - Returns: The new instance of `SwinjectStoryboard`.
    public class func create(name: String,
                             bundle storyboardBundleOrNil: Bundle?,
                             container: Resolver) -> SwinjectStoryboard {
        // Use this factory method to create an instance because the initializer of UI/NSStoryboard is "not inherited".
        let storyboard = SwinjectStoryboard._create(name, bundle: storyboardBundleOrNil)
        storyboard.container = Box(container)
        return storyboard
    }

    /// Instantiates the view controller with the specified identifier.
    /// The view controller and its child controllers have their dependencies injected
    /// as specified in the `Container` passed to the initializer of the `SwinjectStoryboard`.
    ///
    /// - Parameter identifier: The identifier set in the storyboard file.
    ///
    /// - Returns: The instantiated view controller with its dependencies injected.
    public override func instantiateViewController(withIdentifier identifier: String) -> UIViewController {
        SwinjectStoryboard.pushInstantiatingStoryboard(self)
        let viewController = super.instantiateViewController(withIdentifier: identifier)
        SwinjectStoryboard.popInstantiatingStoryboard()
        injectDependency(to: viewController)
        return viewController
    }
    
    private func injectDependency(to viewController: UIViewController) {
        guard !viewController.wasInjected else { return }
        defer { viewController.wasInjected = true }

        let registrationName = viewController.swinjectRegistrationName

        // Xcode 7.1 workaround for Issue #10. This workaround is not necessary with Xcode 7.
        // If a future update of Xcode fixes the problem, replace the resolution with the following code and fix storyboardInitCompleted too.
        // https://github.com/Swinject/Swinject/issues/10
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: viewController))
            typealias FactoryType = ((Resolver, Container.Controller)) -> Any
            _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) in
                factory((self.container.value, viewController)) as Any
            } as Container.Controller?
        } else {
            preconditionFailure("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        for child in viewController.children {
            injectDependency(to: child)
        }
    }
}
#elseif os(OSX)
/// The `SwinjectStoryboard` provides the features to inject dependencies of view/window controllers in a storyboard.
///
/// To specify a registration name of a view/window controller registered to the `Container` as a service type,
/// add a user defined runtime attribute with the following settings:
///
/// - Key Path: `swinjectRegistrationName`
/// - Type: String
/// - Value: Registration name to the `Container`
///
/// in User Defined Runtime Attributes section on Indentity Inspector pane.
/// If no name is supplied to the registration, no runtime attribute should be specified.
@objcMembers
public class SwinjectStoryboard: _SwinjectStoryboardBase, SwinjectStoryboardProtocol {
    /// A shared container used by SwinjectStoryboard instances that are instantiated without specific containers.
    ///
    /// Typical usecases of this property are:
    /// - Implicit instantiation of UIWindow and its root view controller from "Main" storyboard.
    /// - Storyboard references to transit from a storyboard to another.
    public static var defaultContainer = Container()
    
    // Boxing to workaround a runtime error [Xcode 7.1.1 and Xcode 7.2 beta 4]
    // If container property is Resolver type and a Resolver instance is assigned to the property,
    // the program crashes by EXC_BAD_ACCESS, which looks a bug of Swift.
    internal var container: Box<Resolver>!

    private override init() {
        super.init()
    }
   
    /// Creates the new instance of `SwinjectStoryboard`. This method is used instead of an initializer.
    ///
    /// - Parameters:
    ///   - name:      The name of the storyboard resource file without the filename extension.
    ///   - storyboardBundleOrNil:    The bundle containing the storyboard file and its resources. Specify nil to use the main bundle.
    ///
    /// - Note:
    ///                The shared singleton container `SwinjectStoryboard.defaultContainer` is used as the container.
    ///
    /// - Returns: The new instance of `SwinjectStoryboard`.
    public class func create(name: NSStoryboard.Name,
                             bundle storyboardBundleOrNil: Bundle?) -> SwinjectStoryboard {
        SwinjectStoryboard.create(name: name, bundle: storyboardBundleOrNil, container: SwinjectStoryboard.defaultContainer)
    }

    /// Creates the new instance of `SwinjectStoryboard`. This method is used instead of an initializer.
    ///
    /// - Parameters:
    ///   - name:      The name of the storyboard resource file without the filename extension.
    ///   - storyboardBundleOrNil:    The bundle containing the storyboard file and its resources. Specify nil to use the main bundle.
    ///   - container: The container with registrations of the view/window controllers in the storyboard and their dependencies.
    ///
    /// - Returns: The new instance of `SwinjectStoryboard`.
    public class func create(name: NSStoryboard.Name,
                             bundle storyboardBundleOrNil: Bundle?,
                             container: Resolver) -> SwinjectStoryboard {
        // Use this factory method to create an instance because the initializer of UI/NSStoryboard is "not inherited".
        let storyboard = SwinjectStoryboard._create(name, bundle: storyboardBundleOrNil)
        storyboard.container = Box(container)
        return storyboard
    }

    /// Instantiates the view/Window controller with the specified identifier.
    /// The view/window controller and its child controllers have their dependencies injected
    /// as specified in the `Container` passed to the initializer of the `SwinjectStoryboard`.
    ///
    /// - Parameter identifier: The identifier set in the storyboard file.
    ///
    /// - Returns: The instantiated view/window controller with its dependencies injected.
    public override func instantiateController(withIdentifier identifier: NSStoryboard.SceneIdentifier) -> Any {
        SwinjectStoryboard.pushInstantiatingStoryboard(self)
        let controller = super.instantiateController(withIdentifier: identifier)
        SwinjectStoryboard.popInstantiatingStoryboard()
        injectDependency(to: controller)
        return controller
    }
    
    private func injectDependency(to controller: Container.Controller) {
        guard let controller = controller as? InjectionVerifiable, !controller.wasInjected else { return }
        defer { controller.wasInjected = true }
        
        let registrationName = (controller as? RegistrationNameAssociatable)?.swinjectRegistrationName
        // Xcode 7.1 workaround for Issue #10. This workaround is not necessary with Xcode 7.
        // If a future update of Xcode fixes the problem, replace the resolution with the following code and fix storyboardInitCompleted too:
        // https://github.com/Swinject/Swinject/issues/10
        if let container = container.value as? _Resolver {
            let option = SwinjectStoryboardOption(controllerType: type(of: controller))
            typealias FactoryType = ((Resolver, Container.Controller)) -> Any
            _ = container._resolve(name: registrationName, option: option) { (factory: FactoryType) -> Any in
                factory((self.container.value, controller))
            } as Container.Controller?
        } else {
            preconditionFailure("A type conforming Resolver protocol must conform _Resolver protocol too.")
        }
        if let windowController = controller as? NSWindowController, let viewController = windowController.contentViewController {
            injectDependency(to: viewController)
        }
        if let viewController = controller as? NSViewController {
            for child in viewController.childViewControllers {
                injectDependency(to: child)
            }
        }
    }
}
#endif
