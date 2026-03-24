//
//  Film.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 17.07.2025.
//

import Foundation

struct FilmResponse: Decodable {
    let results: [Film]
}

struct Film: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
    }
}

extension Film {
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return Endpoints.filmPosterURL(path: posterPath)
    }
}
