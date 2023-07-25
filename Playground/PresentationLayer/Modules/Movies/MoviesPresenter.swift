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

import CArch

/// Протокол реализующий логику отображения данных
@MainActor protocol MoviesRenderingLogic: RootRenderingLogic {
    
     func display(_ movies: [MovieCell.ModelType])
}

/// Объект содержащий логику преобразования объектов модели `Model` в
/// объекты `UIModel` (ViewModel) модуля `Movies`
final class MoviesPresenter: MoviesPresentationLogic {

    private weak var view: MoviesRenderingLogic?
    private weak var state: MoviesModuleStateRepresentable?

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    init(view: MoviesRenderingLogic,
         state: MoviesModuleStateRepresentable) {
        self.view = view
        self.state = state
    }

    func didObtain(_ movies: [Movie]) {
        Task {
            await view?.display(movies.map { .init($0, formatter) })
        }
    }
    
    func encountered(_ error: Error) {
        Task {
            await view?.displayErrorAlert(with: error)
        }
    }
}

private extension MovieCell.Model {
    
    init(_ movie: Movie, _ formatter: DateFormatter) {
        self.id = movie.id
        self.name = movie.title
        self.rating = movie.voteAverage / 2
        self.posterPath = movie.posterPath ?? ""
        self.releaseDate = formatter.string(from: movie.releaseDate)
    }
}
