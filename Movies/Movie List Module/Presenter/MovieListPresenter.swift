//
//  MovieListPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

protocol MovieListViewProtocol: AnyObject {
    func setMovies(_ moviesArray: [Movie])
    func showErrorAlert(with message: String)
}

protocol MoviesListViewPresenterProtocol: AnyObject {
    init(view: MovieListViewProtocol, router: RouterProtocol)
    func getMovies()
    func tapOnTheMovie(movie: Movie)
}

class MoviesListPresenter: MoviesListViewPresenterProtocol {
    weak var view: MovieListViewProtocol?
    var router: RouterProtocol
    
    required init(view: MovieListViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        getMovies()
    }
    
    func getMovies() {
        NetworkService.shared.getMovies { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let moviesArray):
                    strongSelf.view?.setMovies(moviesArray)
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
