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
    func viewDidLoad()
    func getMovieList(by sort: String, startAgain: Bool)
    func getMovieListBySearch(_ text: String, startAgain: Bool)
    func tapOnTheMovie(with id: Int)
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
        getGenreList()
        getMovieList()
    }
    
    func getMovieList(by sort: String = "popularity.desc", startAgain: Bool = false) {
        if startAgain { movieListPage = 1 }
        let endPoint = EndPoint.list(sort: sort, page: movieListPage)
        movieListRequest(with: endPoint)
    }
    
    func getMovieListBySearch(_ text: String, startAgain: Bool = false) {
        if startAgain { movieListPage = 1 }
        let endPoint = EndPoint.searchMovies(query: text, page: self.movieListPage)
        movieListRequest(with: endPoint)
    }
    
    func tapOnTheMovie(with id: Int) {
        router.showMovieDetails(by: id)
    }
    
    //MARK: - Private -
    private func getGenreList() {
        let endPoint = EndPoint.genres
        NetworkService.shared.request(endPoint: endPoint, expecting: GenreData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let genresArray = data else {return}
                    GenreListConfigurable.shared.genreList = genresArray
                case.failure(let error):
                    let message = "Failed to get genres: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
    
    private func movieListRequest(with endPoint: EndPoint) {
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let moviesArray = data?.results else {return}
                    strongSelf.view?.setMovieList(moviesArray)
                    strongSelf.movieListPage += 1
                case.failure(let error):
                    let message = "Failed to get data: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
}
