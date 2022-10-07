//
//  SwinjectStoryboardProtocol.h
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

// Objective-C optional protocol method is used instead of protocol extension to workaround the issue that
// default implementation of a protocol method is always called if a class method conforming the protocol
// is defined as an extension in a different framework.
@protocol SwinjectStoryboardProtocol

@optional
/// Called by Swinject framework once before SwinjectStoryboard is instantiated.
///
/// - Note:
///   Implement this method and setup the default container if you implicitly instantiate UIWindow
///   and its root view controller from "Main" storyboard.
///
/// ```swift
/// extension SwinjectStoryboard {
///     @objc class func setup() {
///         let container = defaultContainer
///         container.register(SomeType.self) { _ in
///             SomeClass()
///         }
///         container.storyboardInitCompleted(ViewController.self) { r, c in
///             c.something = r.resolve(SomeType.self)
///         }
///     }
/// }
/// ```
+ (void)setup;

@end
