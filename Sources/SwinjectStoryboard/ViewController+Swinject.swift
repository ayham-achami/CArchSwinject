//
//  ViewController+Swinject.swift
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

import ObjectiveC

#if os(iOS) || os(tvOS)
import UIKit

private var uivcWasInjectedKey = "UIViewController.wasInjected"
private var uivcRegistrationNameKey = "UIViewController.swinjectRegistrationName"

// MARK: - UIViewController + RegistrationNameAssociatable + InjectionVerifiable
extension UIViewController: RegistrationNameAssociatable, InjectionVerifiable {
    
    var swinjectRegistrationName: String? {
        get {
            getAssociatedString(key: &uivcRegistrationNameKey)
        }
        set {
            setAssociatedString(newValue, key: &uivcRegistrationNameKey)
        }
    }

    var wasInjected: Bool {
        get {
            getAssociatedBool(key: &uivcWasInjectedKey) ?? false
        }
        set {
            setAssociatedBool(newValue, key: &uivcWasInjectedKey)
        }
    }
}
#elseif os(OSX)
private var nsvcWasInjectedKey = "NSViewController.wasInjected"
private var nswcWasInjectedKey = "NSWindowController.wasInjected"
private var nsvcRegistrationNameKey = "NSViewController.swinjectRegistrationName"
private var nswcRegistrationNameKey = "NSWindowController.swinjectRegistrationName"

// MARK: - NSViewController + RegistrationNameAssociatable + InjectionVerifiable
extension NSViewController: RegistrationNameAssociatable, InjectionVerifiable {
    
    var swinjectRegistrationName: String? {
        get {
            getAssociatedString(key: &nsvcRegistrationNameKey)
        }
        set {
            setAssociatedString(newValue, key: &nsvcRegistrationNameKey)
        }
    }

    var wasInjected: Bool {
        get {
            getAssociatedBool(key: &nsvcWasInjectedKey) ?? false
        }
        set {
            setAssociatedBool(newValue, key: &nsvcWasInjectedKey)
        }
    }
}

// MARK: - NSWindowController + RegistrationNameAssociatable + InjectionVerifiable
extension NSWindowController: RegistrationNameAssociatable, InjectionVerifiable {
    
    var swinjectRegistrationName: String? {
        get {
            getAssociatedString(key: &nsvcRegistrationNameKey)
        }
        set {
            setAssociatedString(newValue, key: &nsvcRegistrationNameKey)
        }
    }

    var wasInjected: Bool {
        get {
            getAssociatedBool(key: &nswcWasInjectedKey) ?? false
        }
        set {
            setAssociatedBool(newValue, key: &nswcWasInjectedKey)
        }
    }
}
#endif

// MARK: - NSObject + Associated
extension NSObject {
    
    func getAssociatedString(key: UnsafeRawPointer) -> String? {
        objc_getAssociatedObject(self, key) as? String
    }

    func setAssociatedString(_ string: String?, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, string, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }

    func getAssociatedBool(key: UnsafeRawPointer) -> Bool? {
        (objc_getAssociatedObject(self, key) as? NSNumber)?.boolValue
    }
    
    func setAssociatedBool(_ bool: Bool, key: UnsafeRawPointer) {
        objc_setAssociatedObject(self, key, NSNumber(value: bool), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
}
