//
//  APIService.swift
//  IMDb App
//
//  Created by Ivan Rybkin
//

import Foundation

protocol APIServiceProtocol {
    func fetchPopularFilms(page: Int, completion: @escaping (Result<[Film], Error>) -> Void)
    func fetchFilmDetails(id: Int, completion: @escaping (Result<FilmDetails, Error>) -> Void)
}

final class APIService: APIServiceProtocol {

    func fetchPopularFilms(page: Int, completion: @escaping (Result<[Film], Error>) -> Void) {
        guard let url = Endpoints.popularFilms(page: page) else {
            DispatchQueue.main.async { completion(.failure(URLError(.badURL))) }
            return
        }

        performRequest(url: url, retryCount: 2, completion: completion)
    }

    // Новый приватный метод с retry
    private func performRequest(url: URL, retryCount: Int, completion: @escaping (Result<[Film], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Network error (retry \(retryCount) left): \(error.localizedDescription)")

                if retryCount > 0 {
                    // Пробуем ещё раз через 1 секунду
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
                        self?.performRequest(url: url, retryCount: retryCount - 1, completion: completion)
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(URLError(.cannotParseResponse))) }
                return
            }

            do {
                let response = try JSONDecoder().decode(FilmResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.results))
                }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    // fetchFilmDetails оставил почти без изменений, только добавил DispatchQueue.main
    func fetchFilmDetails(id: Int, completion: @escaping (Result<FilmDetails, Error>) -> Void) {
        guard let url = URL(string: "\(Endpoints.baseURL)/movie/\(id)?api_key=\(Endpoints.apiKey)&language=en-US") else {
            DispatchQueue.main.async {
                completion(.failure(URLError(.badURL)))
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(URLError(.cannotParseResponse))) }
                return
            }

            do {
                let details = try JSONDecoder().decode(FilmDetails.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(details))
                }
            } catch {
                print("Details decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
