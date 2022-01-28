//
//  MovieData.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

// MARK: - MovieData -
struct MovieData: Codable {
    let results: [MovieModel]
}

// MARK: - Movie -
struct MovieModel: Codable {
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let releaseDate: String?
    let title: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
