//
//  FilmDetails.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import Foundation

struct FilmDetails: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let runtime: Int?
    let voteAverage: Double
    let genres: [Genre]
    let budget: Int?
    let revenue: Int?

    struct Genre: Decodable {
        let id: Int
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, budget, revenue
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
    }
}
