//
//  MovieListPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

protocol MovieListViewProtocol: AnyObject {
    func setMovieList(_ moviesArray: [Movie])
    func showErrorAlert(with message: String)
}

protocol MovieListViewPresenterProtocol: AnyObject {
    init(view: MovieListViewProtocol, router: RouterProtocol)
    func getMovieList()
    func tapOnTheMovie(movie: Movie)
}

class MovieListPresenter: MovieListViewPresenterProtocol {
    //MARK: - Variables -
    weak var view: MovieListViewProtocol?
    var router: RouterProtocol
    private var movieListPage = 1
    
    //MARK: - Life Cycle -
    required init(view: MovieListViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getMovieList()
    }
    
    func getMovieList() {
        let endPoint = EndPoint.popular(page: self.movieListPage)
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let moviesArray = data?.results else {return}
                    strongSelf.view?.setMovieList(moviesArray)
                    strongSelf.movieListPage += 1
                case.failure(let error):
                    let message = "Failed to get places: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
    
    func getMovieListBySearch(_ text: String) {
        let endPoint = EndPoint.searchMovies(query: text)
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let searchMoviesArray = data?.results else {return}
                    strongSelf.view?.setMovieList(searchMoviesArray)
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
