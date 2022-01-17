//
//  GenreData.swift
//  Movies
//
//  Created by Данил Фролов on 17.01.2022.
//

import Foundation



// MARK: - GenreData
struct GenreData: Codable {
    let genres: [MainGenre]
}

// MARK: - Genre
struct MainGenre: Codable {
    let id: Int
    let name: String
}

class Genres {
    static let shared = Genres()
    
    var genreList: GenreData!
    
    func getGenreName(id: Int) -> String {
        let genreElement = genreList.genres.filter { $0.id == id }
        let genreName = genreElement[0].name
        return genreName
    }
}
