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
        return genreList?.first(where: { $0.id == id })?.name ?? ""
    }
    
    func createGenreList(by genreArray: [GenreModel]) -> String? {
        var genreList = String()
        for genre in genreArray {
            genreList.addingDevidingPrefixIfNeeded()
            genreList += genre.name.capitalizingFirstLetter()
        }
        return genreList
    }
    
    func createGenreList(by genreIDS: [Int]) -> String? {
        var genreList = String()
        var genreName = String()
        for id in genreIDS {
            genreName = getGenreName(id: id)
            genreList.addingDevidingPrefixIfNeeded()
            genreList += genreName.capitalizingFirstLetter()
        }
        return genreList
    }
}
