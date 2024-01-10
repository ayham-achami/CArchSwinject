//
//  StoryboardDIAssemblyFactory.swift
//

import CArch
import Foundation
import Swinject
import SwinjectStoryboard

/// Фабрика создания и внедрение зависимости
@available(*, deprecated, message: "Use LayoutAssemblyFactory")
public class StoryboardAssemblyFactory: NSObject, StoryboardDIAssemblyFactory, SwinjectStoryboardProtocol {
    
    public static func set(isDebugEnabled: Bool) {
        Container.loggingFunction = isDebugEnabled ? { print($0) } : nil
    }
    
    static var provider = SwinjectProvider()

    public var storyboardContainer: DIStoryboardContainer {
        Self.provider.container
    }
    
    public var registrar: DIRegistrar {
        Self.provider.container
    }
    
    public var resolver: DIResolver {
        Self.provider.container
    }
    
    public var storyboard: DIStoryboard {
        Self.provider.container
    }
    
    public required override init() {}
    
    public func assembly<Module>(_ module: Module) -> Module where Module: StoryboardModuleAssembly {
        Self.provider.apply(StoryboardModuleApplying(module))
        return module
    }
    
    public func record<Recorder>(_ recorder: Recorder.Type) where Recorder: ServicesRecorder {
        recorder.init().records.forEach { Self.provider.apply(ServicesApplying($0)) }
    }
    
    public func record<Recorder>(_ recorder: Recorder) where Recorder: DIAssemblyCollection {
        recorder.services.forEach { Self.provider.apply(ServicesApplying($0)) }
    }
}

// MARK: - SwinjectStoryboard
@available(*, deprecated, message: "Use LayoutAssemblyFactory")
extension SwinjectStoryboard {

    @objc public class func setup() {
        StoryboardAssemblyFactory.provider = .init(parentContainer: defaultContainer)
        LayoutAssemblyFactory.provider = .init(parentContainer: defaultContainer)
        guard
            StoryboardAssemblyFactory.conforms(to: SwinjectStoryboardProtocol.self),
            StoryboardAssemblyFactory.responds(to: #selector(setup))
        else { return }
        StoryboardAssemblyFactory.perform(#selector(setup))
    }
}
