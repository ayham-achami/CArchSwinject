//
//  MainMainAssemblyTest.swift
//  CArchSwinject
//
//  Created by Ayham Hylam on 02/11/2021.
//  Copyright © 2021 Community Arch. All rights reserved.
//

import XCTest
@testable import Playground

final class MainModuleAssemblyTests: XCTestCase {

    // Проверить, что модуль собирается
    func testAssemblyModule() {
        // Given
        let assembly = MainModule.Builder().build()
        let viewController = assembly.view as? MainViewController

        // Then
        XCTAssertNotNil(viewController, "MainViewController is nil")
        XCTAssertNotNil(viewController?.router, "MainRouter is nil")
        
        XCTAssertNotNil(viewController?.provider, "MainProvider is nil")
        
        guard let provider = (viewController?.provider as? MainProvider) else {
            XCTFail("Provider is not an MainProvider")
            return
        }
        let presenter = Mirror(reflecting: provider)
            .children
            .first(where: { $0.label == "presenter" })?.value as? MainPresenter
        XCTAssertNotNil(presenter, "presenter in MainProvider is nil")
        
        if let presenter = presenter {
            let view = Mirror(reflecting: presenter)
                .children
                .first(where: { $0.label == "view" })?.value as? MainRenderingLogic
            XCTAssertNotNil(view, "view in MainPresenter is nil")
        }
    }
}
