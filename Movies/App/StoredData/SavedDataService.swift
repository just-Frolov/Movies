//
//  SavedDataService.swift
//  Movies
//
//  Created by Данил Фролов on 24.01.2022.
//

import UIKit

class SavedDataServices {
    //MARK: - Static -
    static let shared = SavedDataServices()

    //MARK: - Constant -
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - Private -
    func getAllSavedMovies() -> [StoredMovieModel] {
        do {
            let storedMovies = try context.fetch(StoredMovieModel.fetchRequest())
            return storedMovies
        }
        catch {
            print("Error during get saved movies")
            return []
        }
    }

    func createStoredMovie(from movieData: MovieModel) -> StoredMovieModel {
        let newMovie = StoredMovieModel(context: context)
        newMovie.id = Int32(movieData.id)
        newMovie.poster = movieData.backdropPath
        newMovie.title = movieData.title
        newMovie.genreIDS = movieData.genreIDS
        newMovie.releaseDate = movieData.releaseDate
        newMovie.voteAverage = movieData.voteAverage
        return newMovie
    }

    func save() {
        do {
            try context.save()
        }
        catch {
            print("Error during save movies")
        }
    }
}
