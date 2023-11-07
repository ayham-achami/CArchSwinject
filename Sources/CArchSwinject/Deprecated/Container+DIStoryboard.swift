//
//  Container+DIStoryboard.swift
//

import CArch
import Swinject
import SwinjectStoryboard
import UIKit

// MARK: - Container + DIStoryboard
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
extension Container: DIStoryboard {

    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public func setInitCompleted<Controller>(for controllerType: Controller.Type,
                                             name: String?,
                                             initCompleted: @escaping (DIResolver, Controller) -> Void) where Controller: UIViewController {
        storyboardInitCompleted(controllerType, name: name) { resolver, controller in
            guard let resolver = resolver as? DIResolver else { return }
            initCompleted(resolver, controller)
        }
    }
}
