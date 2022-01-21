//
//  GenreData.swift
//  Movies
//
//  Created by Данил Фролов on 17.01.2022.
//

import Foundation

// MARK: - GenreData -
struct GenreData: Codable {
    let genres: [GenreModel]
}

// MARK: - Genre -
struct GenreModel: Codable {
    let id: Int
    let name: String
}

class GenreListConfigurable {
    static let shared = GenreListConfigurable()
    
    var genreList: GenreData?
    
    func getGenreName(id: Int) -> String {
        guard let safeGenreList = genreList else { return "" }
        let genreElement = safeGenreList.genres.filter { $0.id == id }
        let genreName = genreElement[0].name
        return genreName
    }
}
