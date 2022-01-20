//
//  MovieTrailerData.swift
//  Movies
//
//  Created by Данил Фролов on 16.01.2022.
//
import Foundation

// MARK: - MovieTrailerData -
struct MovieTrailerData: Codable {
    let results: [TrailerId]
}

// MARK: - TrailerId -
struct TrailerId: Codable {
    let key: String
}
