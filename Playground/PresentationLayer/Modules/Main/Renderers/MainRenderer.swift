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
import CArch

/// Протокол взаимодействия пользователя с модулем
protocol MainRendererUserInteraction: AnyUserInteraction {}

/// Объект содержащий логику отображения данных 
final class MainRenderer: UITabBarController, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = Model
    
    struct Model: UIModel {}

    // MARK: - Private properties
    private weak var interactional: MainRendererUserInteraction?
    
    init(interactional: MainRendererUserInteraction) {
        super.init(nibName: nil, bundle: nil)
        self.interactional = interactional
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func set(content: MainRenderer.ModelType) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Renderer + IBAction
private extension MainRenderer {}

// MARK: - Private methods
extension MainRenderer: UIRendererPreview {
    
    final class InteractionalPreview: MainRendererUserInteraction {}
    
    static let interactional: InteractionalPreview = .init()
    
    static func preview() -> Self {
        let preview = Self.init(interactional: interactional)
        preview.moduleDidLoad()
        return preview
    }
}

#Preview(String(describing: MainRenderer.self)) {
    MainRenderer.preview()
}
