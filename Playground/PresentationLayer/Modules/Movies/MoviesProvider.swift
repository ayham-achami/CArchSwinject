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
import CArch

/// Протокол взаимодействия с `MoviesPresenter`
protocol MoviesPresentationLogic: RootPresentationLogic {
    
    func didObtain(_ movies: [Movie])
}

/// Объект содержаний логику получения данных из слоя бизнес логики
/// все типы данных передаются `MoviesPresenter` как `UIModel`
final class MoviesProvider: MoviesProvisionLogic {

    private let presenter: MoviesPresentationLogic
    private let moviesService: MoviesService

    /// Инициализация провайдера модуля `Movies`
    /// - Parameter presenter: `MoviesPresenter`
    /// - Parameter moviesService: `MoviesService`
    nonisolated init(presenter: MoviesPresentationLogic,
                     moviesService: MoviesService) {
        self.presenter = presenter
        self.moviesService = moviesService
    }
    
    func obtainMovies(of type: MoviesModuleState.MoviesType, at page: Int) {
        Task {
            do {
                let movies: Movies
                switch type {
                case .popular:
                    movies = try await moviesService.fetchPopular(page)
                case .upcoming:
                    movies = try await moviesService.fetchUpcoming(page)
                case .topRated:
                    movies = try await moviesService.fetchTopRated(page)
                case .nowPlaying:
                    movies = try await moviesService.fetchNowPlaying(page)
                }
                presenter.didObtain(movies.results)
            } catch {
                presenter.encountered(error)
            }
        }
    }
}
