//
//  MovieDetailsData.swift
//  Movies
//
//  Created by Данил Фролов on 14.01.2022.
//

import Alamofire

// MARK: - MovieDetailsData -
struct MovieDetailsData: Codable {
    let budget: Int
    let genres: [GenreModel]
    let id: Int
    let backdropPath: String?
    let productionCountries: [CountryNameModel]
    let releaseDate: String?
    let originalTitle, overview, title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case budget, genres, id, overview, title
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

// MARK: - Genre -
struct CountryNameModel: Codable {
    var name: String
}
