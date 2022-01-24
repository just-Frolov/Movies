//
//  MovieListPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

protocol MovieListViewProtocol: AnyObject {
    func setMovieList(_ moviesArray: [StoredMovieModel])
    func showErrorAlert(with message: String)
    func searchDesiredMoviesLocally()
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
    private var startMovieList = [StoredMovieModel]() {
        didSet {
            storedMovie.save()
        }
    }
    
    //MARK: - Constants -
    private let group = DispatchGroup()
    private let storedMovie = SavedDataServices.shared
    
    //MARK: - Life Cycle -
    required init(view: MovieListViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        if NetworkMonitor.shared.isConnected {
            getGenreList()
            getMovieList()
        } else {
            let movieList = storedMovie.getAllSavedMovies()
            view?.setMovieList(movieList)
            showOfflineAlert()
        }
    }
    
    func getMovieList(by sort: String = "popularity.desc", startAgain: Bool = false) {
        if startAgain { movieListPage = 1 }
        guard NetworkMonitor.shared.isConnected else {
            showOfflineAlert()
            return
        }
        let endPoint = EndPoint.list(sort: sort, page: movieListPage)
        movieListRequest(with: endPoint)
    }
    
    func getMovieListBySearch(_ text: String, startAgain: Bool = false) {
        if startAgain { movieListPage = 1 }
        guard NetworkMonitor.shared.isConnected else {
            view?.searchDesiredMoviesLocally()
            return
        }
        let endPoint = EndPoint.searchMovies(query: text, page: self.movieListPage)
        movieListRequest(with: endPoint)
    }
    
    func tapOnTheMovie(with id: Int) {
        guard NetworkMonitor.shared.isConnected else {
            showOfflineAlert()
            return
        }
        router.showMovieDetails(by: id)
    }
    
    //MARK: - Private -
    private func showOfflineAlert() {
        let message = "You are offline. Please, enable your Wi-Fi or connect using cellular data."
        view?.showErrorAlert(with: message)
    }
    
    private func getGenreList() {
        group.enter()
        let endPoint = EndPoint.genres
        NetworkService.shared.request(endPoint: endPoint, expecting: GenreData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case.success(let data):
                guard let genresArray = data else {return}
                GenreListConfigurable.shared.genreList = genresArray
                strongSelf.group.leave()
            case.failure(let error):
                let message = "Failed to get genres: \(error)"
                strongSelf.view?.showErrorAlert(with: message)
            }
            
        }
    }
    
    private func movieListRequest(with endPoint: EndPoint) {
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case.success(let data):
                guard let movieRequestResult = data?.results else {return}
                
                strongSelf.group.notify(queue: .main) {
                    let moviesArray = movieRequestResult.map { strongSelf.storedMovie.createStoredMovie(from: $0) }
                    strongSelf.view?.setMovieList(moviesArray)
                    
                    if strongSelf.startMovieList.isEmpty {
                        strongSelf.startMovieList = moviesArray
                    }
                }
                
                strongSelf.movieListPage += 1
            case.failure(let error):
                let message = "Failed to get data: \(error)"
                strongSelf.view?.showErrorAlert(with: message)
            }
            
        }
    }
}
