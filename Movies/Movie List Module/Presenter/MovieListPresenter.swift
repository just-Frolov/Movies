//
//  MovieListPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

protocol MoviesListViewProtocol: AnyObject {
    func setMovies()
    func showErrorAlert(with message: String)
}

protocol MoviesListViewPresenterProtocol: AnyObject {
    init(view: MoviesListViewProtocol, router: RouterProtocol)
    var movies: [Movie]? { get set }
    func getMovies()
    func tapOnTheMovie(movie: Movie)
}

class MoviesListPresenter: MoviesListViewPresenterProtocol {
    weak var view: MoviesListViewProtocol?
    var router: RouterProtocol
    var movies: [Movie]?
    
    required init(view: MoviesListViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func getMovies() {
        NetworkService.shared.getMovies { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let moviesArray):
                    strongSelf.movies = moviesArray
                    strongSelf.view?.setMovies()
                case.failure(let error):
                    let message = "Failed to get places: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
    
    func tapOnTheMovie(movie: Movie) {
        router.showDetail(movie: movie)
    }
}
