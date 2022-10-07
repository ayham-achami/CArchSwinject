//
//  SwinjectStoryboard+StoryboardReference.
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

private var storyboardStack = [SwinjectStoryboard]()

extension SwinjectStoryboard {

    class var isCreatingStoryboardReference: Bool {
        referencingStoryboard != nil
    }

    static var referencingStoryboard: SwinjectStoryboard? {
        storyboardStack.last
    }
    
    static func pushInstantiatingStoryboard(_ storyboard: SwinjectStoryboard) {
        storyboardStack.append(storyboard)
    }

    @discardableResult
    static func popInstantiatingStoryboard() -> SwinjectStoryboard? {
        storyboardStack.popLast()
    }
}

#if os(iOS) || os(tvOS)
extension SwinjectStoryboard {
    
    class func createReferenced(name: String, bundle storyboardBundleOrNil: Bundle?) -> SwinjectStoryboard {
        if let container = referencingStoryboard?.container.value {
            return create(name: name, bundle: storyboardBundleOrNil, container: container)
        } else {
            return create(name: name, bundle: storyboardBundleOrNil)
        }
    }
}
#elseif os(OSX)
extension SwinjectStoryboard {
    
    class func createReferenced(name: NSStoryboard.Name, bundle storyboardBundleOrNil: Bundle?) -> SwinjectStoryboard {
        if let container = referencingStoryboard?.container.value {
            return create(name: name, bundle: storyboardBundleOrNil, container: container)
        } else {
            return create(name: name, bundle: storyboardBundleOrNil)
        }
    }
}
#endif
