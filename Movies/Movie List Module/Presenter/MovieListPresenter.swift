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
    func setOfflineMode()
    func setOnlineMode()
}

protocol MovieListViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getMovieList(by sort: String, startAgain: Bool)
    func getMovieListBySearch(query: String, deadline: Int, startAgain: Bool)
    func getMoreMovies()
    func moviePosterTapped(with id: Int)
}

class MovieListPresenter: MovieListViewPresenterProtocol {
    //MARK: - Variables -
    weak var view: MovieListViewProtocol?
    private var router: RouterProtocol
    private var movieListPage = 1
    private var movieSearchText = String()
    private var movieSortingType = Constants.SortType.byPopular
    private var workItemForSearchBar: DispatchWorkItem?
    
    //MARK: - Constants -
    private let genreGroup = DispatchGroup()
    private let storedService = SavedDataServices.shared
    
    //MARK: - Life Cycle -
    required init(view: MovieListViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        if NetworkMonitor.shared.isConnected {
            getGenreList()
            getMovieList()
            view?.setOnlineMode()
        } else {
            getSavedData()
            view?.setOfflineMode()
        }
        addTriggerToChangeTheInternet()
    }
    
    func getMovieList(by sort: String = "", startAgain: Bool = false) {
        resetValueForCurrentVariables(sort: sort, startAgain: startAgain)
        guard NetworkMonitor.shared.isConnected else {
            if startAgain {
                getSavedData()
            }
            return
        }
        let endPoint = EndPoint.list(sort: movieSortingType, page: movieListPage)
        movieListRequest(with: endPoint)
    }
    
    func getMovieListBySearch(query: String, deadline: Int = 0, startAgain: Bool = false) {
        workItemForSearchBar?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.resetValueForCurrentVariables(searchText: query, startAgain: startAgain)
            self?.movieSearchText == "" ? self?.getMovieList(startAgain: true) : self?.startMovieSearchRequest(query)
        }
        workItemForSearchBar = newWorkItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(deadline),
                                          execute: newWorkItem)
    }
    
    func moviePosterTapped(with id: Int) {
        guard NetworkMonitor.shared.isConnected else {
            view?.setOfflineMode()
            return
        }
        router.showMovieDetails(by: id)
    }
    
    func getMoreMovies() {
        movieSearchText != "" ? getMovieListBySearch(query: movieSearchText) : getMovieList()
    }
    
    //MARK: - Private -
    private func resetValueForCurrentVariables(sort: String = "", searchText: String = "", startAgain: Bool) {
        movieSearchText = searchText
        if startAgain {
            movieListPage = 1
        }
        if sort != "" {
            movieSortingType = sort
        }
    }
    
    private func getSavedData() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let genreList = strongSelf.storedService.getAllSavedGenres()
            let movieList = strongSelf.storedService.getSavedMovies()
            GenreListConfigurable.shared.genreList = genreList
            strongSelf.view?.setMovieList(movieList)
            strongSelf.view?.setOfflineMode()
        }
    }
    
    private func getGenreList() {
        genreGroup.enter()
        let endPoint = EndPoint.genres
        NetworkService.shared.request(endPoint: endPoint,
                                      expecting: GenreData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let genreRequestResult = data else { return }
                    
                    let genreRequestList = genreRequestResult.genres
                    let genresArray = genreRequestList.map {
                        strongSelf.storedService.createStoredGenre(from: $0)
                    }
                    GenreListConfigurable.shared.genreList = genresArray
                    strongSelf.genreGroup.leave()
                case.failure(let error):
                    let message = "Failed to get genres: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                    strongSelf.genreGroup.leave()
                }
            }
        }
    }
    
    private func movieListRequest(with endPoint: EndPoint) {
        NetworkService.shared.request(endPoint: endPoint,
                                      expecting: MovieData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //genreGroup.notify(queue: <#T##DispatchQueue#>, work: <#T##DispatchWorkItem#>)
                switch result {
                case.success(let data):
                    guard let movieRequestResult = data?.results else { return }
                    
                    
                    let moviesArray = movieRequestResult.map {
                        strongSelf.storedService.createStoredMovie(from: $0)
                    }
                    strongSelf.view?.setMovieList(moviesArray)
                    strongSelf.storedService.saveContext()
                    
                    
                    strongSelf.movieListPage += 1
                case.failure(let error):
                    let message = "Failed to get data: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
    
    private func startMovieSearchRequest(_ filter: String) {
        guard NetworkMonitor.shared.isConnected else {
            DispatchQueue.main.async { [weak self] in
                self?.view?.setMovieList(self?.storedService.getSavedMovies(by: filter) ?? [])
            }
            return
        }
        let endPoint = EndPoint.searchMovies(query: filter, page: movieListPage)
        movieListRequest(with: endPoint)
    }
    
    private func addTriggerToChangeTheInternet() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeNetworkStatus),
            name: Notification.Name.networkStatusWasChanged,
            object: nil)
    }
    
    @objc func changeNetworkStatus() {
        NetworkMonitor.shared.isConnected ? view?.setOnlineMode() : view?.setOfflineMode()
    }
}
