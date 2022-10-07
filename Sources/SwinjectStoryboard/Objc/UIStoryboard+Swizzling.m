//
//  UIStoryboard+Swizzling.m
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

#import "UIStoryboard+Swizzling.h"
#import <objc/runtime.h>
#import <CArchSwinject/SwinjectStoryboardProtocol.h>

#if __has_include(<CArchSwinject/CArchSwinject-Swift.h>)
    #import <CArchSwinject/CArchSwinject-Swift.h>
#elif __has_include("CArchSwinject-Swift.h")
    #import "CArchSwinject-Swift.h"
#endif

@implementation UIStoryboard (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = object_getClass((id)self);

        SEL originalSelector = @selector(storyboardWithName:bundle:);
        SEL swizzledSelector = @selector(swinject_storyboardWithName:bundle:);

        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (nonnull instancetype)swinject_storyboardWithName:(NSString *)name bundle:(nullable NSBundle *)storyboardBundleOrNil {
    if (self == [UIStoryboard class]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

        // Instantiate SwinjectStoryboard if UIStoryboard is trying to be instantiated.
        if ((BOOL)[[SwinjectStoryboard class] performSelector:@selector(isCreatingStoryboardReference)]) {
            return [[SwinjectStoryboard class] performSelector:@selector(createReferencedWithName:bundle:)
                                                    withObject: name
                                                    withObject: storyboardBundleOrNil];
        } else {
            return [SwinjectStoryboard createWithName:name bundle:storyboardBundleOrNil];
        }
#pragma clang diagnostic pop
    } else {
        return [self swinject_storyboardWithName:name bundle:storyboardBundleOrNil];
    }
}

@end
