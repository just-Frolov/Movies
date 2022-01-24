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
    
    var genreList: [StoredGenreModel]?
    
    func getGenreName(id: Int) -> String {
        guard let safeGenreList = genreList else { return "" }
        let genreElement = safeGenreList.filter { $0.id == id }
        guard !genreElement.isEmpty else { return "" }
        let genreName = genreElement[0].name
        return genreName ?? ""
    }
}
