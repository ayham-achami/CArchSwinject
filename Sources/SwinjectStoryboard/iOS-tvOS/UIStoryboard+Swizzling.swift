#if canImport(UIKit)
//
//  UIStoryboard+Swizzling.swift
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

import UIKit

extension UIStoryboard {
    
    static func swizzling() {
        DispatchQueue.once(token: "swinject.storyboard.init") {
            let aClass: AnyClass = object_getClass(self)!

            let originalSelector = #selector(UIStoryboard.init(name:bundle:))
            let swizzledSelector = #selector(swinject_init(name:bundle:))

            let originalMethod = class_getInstanceMethod(aClass, originalSelector)!
            let swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector)!

            let didAddMethod = class_addMethod(aClass, originalSelector,
                                               method_getImplementation(swizzledMethod),
                                               method_getTypeEncoding(swizzledMethod))

            guard didAddMethod else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
                return
            }
            class_replaceMethod(aClass, swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        }
    }

    @objc class func swinject_init(name: String, bundle: Bundle?) -> UIStoryboard {
        guard self == UIStoryboard.self else {
            return self.swinject_init(name: name, bundle: bundle)
        }
        // Instantiate SwinjectStoryboard if UIStoryboard is trying to be instantiated.
        if SwinjectStoryboard.isCreatingStoryboardReference {
            return SwinjectStoryboard.createReferenced(name: name, bundle: bundle)
        } else {
            return SwinjectStoryboard.create(name: name, bundle: bundle)
        }
    }
}
#endif
