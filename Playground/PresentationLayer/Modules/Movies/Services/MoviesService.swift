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
import Foundation

final class MoviesServiceAssembly: DIAssembly {
    
    func assemble(container: DIContainer) {
        container.record(MoviesService.self, inScope: .autoRelease) { _ in
            MoviesServiceImplementation()
        }
    }
}

enum MoviesFetchError: Error {
    
    case response
    case invalidate(Int)
}

@MaintenanceActor protocol MoviesService: BusinessLogicService {

    func fetchNowPlaying(_ page: Int) async throws -> Movies
    
    func fetchPopular(_ page: Int) async throws -> Movies
    
    func fetchTopRated(_ page: Int) async throws -> Movies
    
    func fetchUpcoming(_ page: Int) async throws -> Movies
}

private final class MoviesServiceImplementation: MoviesService {
    
    nonisolated init() {}
    
    private let headers = ["accept": "application/json",
                           "Authorization": "Bearer \(token)"]
    private let baseURL = URL(string: "https://api.themoviedb.org/3/movie")!
    
    func fetchNowPlaying(_ page: Int) async throws -> Movies {
        let request = request(for: "now_playing", and: page)
        let (data, response) = try await URLSession.shared.data(for: request)
        try checkStatusCode(of: response)
        return try JSONDecoder.default.decode(Movies.self, from: data)
    }
    
    func fetchPopular(_ page: Int) async throws -> Movies {
        let request = request(for: "popular", and: page)
        let (data, response) = try await URLSession.shared.data(for: request)
        try checkStatusCode(of: response)
        return try JSONDecoder.default.decode(Movies.self, from: data)
    }
    
    func fetchTopRated(_ page: Int) async throws -> Movies {
        let request = request(for: "top_rated", and: page)
        let (data, response) = try await URLSession.shared.data(for: request)
        try checkStatusCode(of: response)
        return try JSONDecoder.default.decode(Movies.self, from: data)
    }
    
    func fetchUpcoming(_ page: Int) async throws -> Movies {
        let request = request(for: "upcoming", and: page)
        let (data, response) = try await URLSession.shared.data(for: request)
        try checkStatusCode(of: response)
        return try JSONDecoder.default.decode(Movies.self, from: data)
    }
    
    private func request(for path: String, and page: Int) -> URLRequest {
        let url = baseURL
            .appending(path: path)
            .appending(queryItems: [.init(name: "page", value: "\(page)")])
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private func checkStatusCode(of response: URLResponse) throws {
        guard
            let response = response as? HTTPURLResponse
        else { throw MoviesFetchError.response }
        guard
            (200...299).contains(response.statusCode)
        else { throw MoviesFetchError.invalidate(response.statusCode) }
    }
}
