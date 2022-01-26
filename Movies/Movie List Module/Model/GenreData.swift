//
//  GenreData.swift
//  Movies
//
//  Created by Данил Фролов on 17.01.2022.
//

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
        let genreName = genreElement.first?.name
        return genreName ?? ""
    }
    
    func createGenreList(by genreArray: [GenreModel]) -> String? {
        var genreList = String()
        for genre in genreArray {
            genreList.addingDevidingPrefixIfNeeded()
            genreList += genre.name.capitalizingFirstLetter()
        }
        return genreList
    }
}
