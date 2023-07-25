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
import CArchSwinject

let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3NWQ4YTY1MDVkYmU2Y2NhODc5MmEwODJlNmI2ZDU2ZSIsInN1YiI6IjVjODE0NmY3YzNhMzY4NGU4ZmQ2M2E0ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.-1fOBevFQKbPvFdbVs4zFDwHUJknj3644PHInA1tWSw"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var mainWindow: UIWindow = {
        .init(frame: UIScreen.main.bounds)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        LayoutAssemblyFactory().record(BusinessLogicServicesFactory.self)
        mainWindow.rootViewController = MainModule.Builder().build().node
        mainWindow.makeKeyAndVisible()
        return true
    }
}
