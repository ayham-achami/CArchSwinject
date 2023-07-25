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
protocol MoviesRendererUserInteraction: AnyUserInteraction {
    
    func didRequestMoreMovies()
}

/// Объект содержащий логику отображения данных
final class MoviesRenderer: UICollectionView, UIRenderer {
    
    // MARK: - Renderer model
    typealias ModelType = [MovieCell.ModelType]

    private let cellId = "\(String(describing: MoviesRenderer.self)).\(String(describing: MovieCell.self))"
    
    // MARK: - Private properties
    private weak var interactional: MoviesRendererUserInteraction?
    private var content: ModelType = []
    
    init(interactional: MoviesRendererUserInteraction) {
        super.init(frame: .zero, collectionViewLayout: MoviesLayout())
        self.interactional = interactional
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func set(content: ModelType) {
        self.content.append(contentsOf: content)
        reloadData()
    }
    
    func moduleDidLoad() {
        delegate = self
        dataSource = self
        register(MovieCell.self, forCellWithReuseIdentifier: cellId)
    }
}

// MARK: - Renderer + IBAction
private extension MoviesRenderer {}

// MARK: - MoviesRenderer + UICollectionViewDataSource
extension MoviesRenderer: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MovieCell
        else { preconditionFailure("Cell must be a instance of MovieCell") }
        let model = content[indexPath.row]
        cell.set(content: model)
        return cell
    }
}

// MARK: - MoviesRenderer + UICollectionViewDelegate
extension MoviesRenderer: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == content.count - 1 {
            interactional?.didRequestMoreMovies()
        }
    }
}

// MARK: - Private methods
extension MoviesRenderer: UIRendererPreview {
    
    final class InteractionalPreview: MoviesRendererUserInteraction {
        
        func didRequestMoreMovies() {
            print(#function)
        }
    }
    
    static let interactional: InteractionalPreview = .init()
    
    static func preview() -> Self {
        let preview = Self.init(interactional: interactional)
        preview.moduleDidLoad()
        preview.set(content: (1...10).map { id in
            let path = (id % 2) == 0 ? "/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg" : "/ym1dxyOk4jFcSl4Q2zmRrA5BEEN.jpg"
            return .init(id: id,
                         name: "John Wick: Chapter 4",
                         rating: 3.8,
                         posterPath: path,
                         releaseDate: "03/24/2023")
        })
        return preview
    }
}

#Preview(String(describing: MainRenderer.self)) {
    MoviesRenderer.preview()
}
