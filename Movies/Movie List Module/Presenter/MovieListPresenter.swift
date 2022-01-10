//
//  MovieListPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

protocol MoviesListViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
}

protocol MoviesListViewPresenterProtocol: AnyObject {
    init(view: MoviesListViewProtocol, networkService: MoviesManagerProtocol, router: RouterProtocol)
    var movies: [Movie]? { get set }
    func tapOnTheMovie(movie: Movie)
    func getComments()
}

class MoviesListPresenter: MoviesListViewPresenterProtocol {
    weak var view: MoviesListViewProtocol?
    let networkService: MoviesManagerProtocol
    var router: RouterProtocol
    var movies: [Movie]?
    
    required init(view: MoviesListViewProtocol, networkService: MoviesManagerProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func getComments() {
        networkService.getComments { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let moviesArray):
                    strongSelf.movies = moviesArray
                    strongSelf.view?.succes()
                case.failure(let error):
                    strongSelf.view?.failure(error: error)
                }
            }
        }
    }
    
    func tapOnTheMovie(movie: Movie) {
        router.showDetail(movie: movie)
    }
}
