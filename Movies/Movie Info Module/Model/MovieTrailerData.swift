//
//  MovieTrailerData.swift
//  Movies
//
//  Created by Данил Фролов on 16.01.2022.
//

// MARK: - MovieTrailerData -
struct MovieTrailerData: Codable {
    let results: [TrailerIdModel]
}

// MARK: - TrailerId -
struct TrailerIdModel: Codable {
    let key: String
}
