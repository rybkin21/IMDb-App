//
//  APIService.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 17.07.2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchPopularFulms(page: Int, completion: @escaping (Result<[Film], Error>) -> Void)
}

final class APIService: APIServiceProtocol {

    func fetchPopularFulms(page: Int, completion: @escaping (Result<[Film], any Error>) -> Void) {
        guard let url = Endpoints.popularFilms(page: page) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }

            do {
                let response = try JSONDecoder().decode(FilmResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
