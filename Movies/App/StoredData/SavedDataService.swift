//
//  SavedDataService.swift
//  Movies
//
//  Created by Данил Фролов on 24.01.2022.
//

import UIKit
import CoreData

class SavedDataServices {
    //MARK: - Static -
    static let shared = SavedDataServices()
    
    //MARK: - Variables -
    private var context: NSManagedObjectContext {
        let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        viewContext.mergePolicy = NSOverwriteMergePolicy
        return viewContext
    }
    
    //MARK: - Internal -
    func getSavedMovies(by filter: String? = nil) -> [StoredMovieModel] {
        do {
            let fetchRequest = StoredMovieModel.fetchRequest()
            let sort = NSSortDescriptor(key: #keyPath(StoredMovieModel.title), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            if let filter = filter {
                let predicate = NSPredicate(format: "title CONTAINS[c] %@", filter)
                fetchRequest.predicate = predicate
            }
            let storedMovies = try context.fetch(fetchRequest)
            return storedMovies
        } catch {
            print("Error during get saved movies by filter")
            return []
        }
    }
    
    
    func getAllSavedGenres() -> [StoredGenreModel] {
        do {
            let storedGenres = try context.fetch(StoredGenreModel.fetchRequest())
            return storedGenres
        } catch {
            print("Error during get saved genres")
            return []
        }
    }
    
    func createStoredGenre(from genreData: GenreModel) -> StoredGenreModel {
        let newGenre = StoredGenreModel(context: context)
        newGenre.id = Int32(genreData.id)
        newGenre.name = genreData.name
        return newGenre
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
        catch let error {
            print("Error during save movies\(error)")
        }
    }
}
