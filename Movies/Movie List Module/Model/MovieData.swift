//
//  MovieData.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import Foundation


// MARK: - MovieData
struct MovieData: Codable {
    let results: [Movie]
}

// MARK: - Movie
struct Movie: Codable {
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview, posterPath: String
    let releaseDate, title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
