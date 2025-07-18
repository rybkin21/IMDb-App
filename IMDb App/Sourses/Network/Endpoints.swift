//
//  Endpoints.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 17.07.2025.
//

import Foundation

enum Endpoints {
    static let apiKey = "081d546e4bd131a869a23cfc760b49f7"
    static let baseURL = "https://api.themoviedb.org/3"

    static func popularFilms(page: Int) -> URL? {
        return URL(string: "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(page)")
    }

    static func filmPosterURL(path: String) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
