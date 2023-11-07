//
//  UIViewController+LMA.swift
//

#if canImport(UIKit)
import CArch
import UIKit

// MARK: - UIViewController + ModuleAssembler
@available(*, deprecated, message: "This feature has be deprecated and will be removed in future release")
extension UIViewController: LayoutModuleAssembler {
    
    public static func assembly<Module>(_ type: Module.Type) -> StorageType.WeakReference<Module> where Module: AnyObject, Module: LayoutModuleAssembly {
        .init(LayoutAssemblyFactory().assembly(Module()))
    }
}
#endif
