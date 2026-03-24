//
//  Endpoints.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 17.07.2025.
//

import Foundation

enum Endpoints {
    static let apiKey = "d1a36e581c6200cf1e8b9f0415aa9ba3"
    static let baseURL = "https://api.themoviedb.org/3"

    static func popularFilms(page: Int) -> URL? {
        URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)")
    }

    static func filmPosterURL(path: String) -> URL? {
        URL(string: "https://image.tmdb.org/t/p/w342\(path)")   // w342 лучше выглядит на iPhone
    }

    // Бонус: детали фильма
    static func filmDetails(id: Int) -> URL? {
        URL(string: "\(baseURL)/movie/\(id)?api_key=\(apiKey)&language=ru-RU")
    }
}
