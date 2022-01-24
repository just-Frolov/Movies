//
//  MovieDetailsData.swift
//  Movies
//
//  Created by Данил Фролов on 14.01.2022.
//

import Alamofire

// MARK: - MovieDetailsData -
struct MovieDetailsData: Codable {
    let budget, revenue, id: Int
    let genres: [GenreModel]
    let productionCountries: [CountryNameModel]
    let releaseDate, backdropPath: String?
    let originalTitle, overview, title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case budget, genres, id, overview, title, revenue
        case originalTitle = "original_title"
        case backdropPath = "backdrop_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

// MARK: - CountryNameModel -
struct CountryNameModel: Codable {
    var name: String
}
