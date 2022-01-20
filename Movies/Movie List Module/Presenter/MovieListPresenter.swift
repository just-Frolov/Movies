//
//  MovieListPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit
import RealmSwift

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
    private var startMovieList = [Movie]() {
        didSet {
            do {
                try realm.write {
                    startMovieList
                }
            } catch  {
                print("Error saving movie \(error)")
            }
        }
    }
    
    //MARK: - Constants -
    private let group = DispatchGroup()
    let realm = try! Realm()
    
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
            loadLastMovies()
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
            showOfflineAlert()
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
    private func loadLastMovies() {
        //let movieList = realm.objects(Movie.self)
    }
    
    private func showOfflineAlert() {
        let message = "You are offline. Please, enable your Wi-Fi or connect using cellular data."
        view?.showErrorAlert(with: message)
    }
    
    private func getGenreList() {
        group.enter()
        let endPoint = EndPoint.genres
        NetworkService.shared.request(endPoint: endPoint, expecting: GenreData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
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
    }
    
    private func movieListRequest(with endPoint: EndPoint) {
        if GenreListConfigurable.shared.genreList == nil {
            getGenreList()
        }
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let moviesArray = data?.results else {return}
                    strongSelf.group.notify(queue: .main) {
                        strongSelf.view?.setMovieList(moviesArray)
                    }
                    if strongSelf.startMovieList.isEmpty {
                        strongSelf.startMovieList = moviesArray
                    }
                    strongSelf.movieListPage += 1
                case.failure(let error):
                    let message = "Failed to get data: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
}
