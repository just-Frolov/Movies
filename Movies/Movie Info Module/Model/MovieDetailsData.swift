//
//  MovieDetailsData.swift
//  Movies
//
//  Created by Данил Фролов on 14.01.2022.
//

import Alamofire

// MARK: - MovieDetailsData
struct MovieDetailsData: Codable {
    let budget: Int
    let genres: [Genre]
    let id: Int
    let backdropPath: String?
    let productionCountries: [Genre]
    let releaseDate: String?
    let originalTitle, overview, tagline, title: String
    let video: Bool
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case budget, genres, id, overview
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case tagline, title, video
        case voteAverage = "vote_average"
    }
}

// MARK: - Genre
struct Genre: Codable {
    var name: String
}
