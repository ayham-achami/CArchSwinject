//
//  SwinjectStoryboard+StoryboardReference.swift
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

import Foundation
#if canImport(UIKit)
    import UIKit
#elseif canImport(Cocoa)
    import Cocoa
#endif

internal extension SwinjectStoryboard {

    static func pushInstantiatingStoryboard(_ storyboard: SwinjectStoryboard) {
        storyboardStack.append(storyboard)
    }

    @discardableResult
    static func popInstantiatingStoryboard() -> SwinjectStoryboard? {
        return storyboardStack.popLast()
    }

    class var isCreatingStoryboardReference: Bool {
        return referencingStoryboard != nil
    }

    static var referencingStoryboard: SwinjectStoryboard? {
        return storyboardStack.last
    }
#if os(iOS) || os(tvOS)
    class func createReferenced(name: String, bundle storyboardBundleOrNil: Bundle?) -> SwinjectStoryboard {
        if let container = referencingStoryboard?.container.value {
            return create(name: name, bundle: storyboardBundleOrNil, container: container)
        } else {
            return create(name: name, bundle: storyboardBundleOrNil)
        }
    }
#elseif os(OSX)
    class func createReferenced(name: NSStoryboard.Name, bundle storyboardBundleOrNil: Bundle?) -> SwinjectStoryboard {
        if let container = referencingStoryboard?.container.value {
            return create(name: name, bundle: storyboardBundleOrNil, container: container)
        } else {
            return create(name: name, bundle: storyboardBundleOrNil)
        }
    }
#endif
}

private var storyboardStack = [SwinjectStoryboard]()
