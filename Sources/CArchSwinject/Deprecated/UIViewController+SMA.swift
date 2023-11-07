//
//  UIViewController+SMA.swift
//

#if canImport(UIKit)
import CArch
import UIKit

// MARK: - UIViewController + ModuleAssembler
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
extension UIViewController: StoryboardModuleAssembler {
    
    @available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
    public static func assembly<Module>(_ type: Module.Type) ->
        StorageType.WeakReference<Module> where Module: AnyObject, Module: StoryboardModuleAssembly {
        .init(StoryboardAssemblyFactory().assembly(Module()))
    }
}
#endif
