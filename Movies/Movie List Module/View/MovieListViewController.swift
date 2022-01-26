//
//  ViewController.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import SnapKit
import JGProgressHUD

class MovieListViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Movies..."
        searchBar.backgroundColor = .white
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.keyboardDismissMode = .onDrag
        MoviesTableViewCell.register(in: table)
        return table
    }()
    
    private lazy var noMoviesLabel: UILabel = {
        let label = UILabel()
        label.text = "No movies found for your search!"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    var presenter: MovieListViewPresenterProtocol!
    private var currentMovieList = [StoredMovieModel]()
    private var movieSearchText = String()
    private var movieSortingType = Constants.SortType.byPopular
    
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = Constants.appName
    }
    
    //MARK: - Private -
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        setupSearchBar()
    }
    
    private func setupNavigationBar() {
        setupNavigationBarAppearence()
    }
    
    private func setNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down.square"),
            style: .done,
            target: self,
            action: #selector(showActionSheetWithSortingType)
        )
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupNavigationBarAppearence() {
        let navAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
        navigationController?.navigationBar.standardAppearance = navAppearance
    }
    
    private func addSubViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(noMoviesLabel)
    }
    
    private func setupConstraints() {
        setupSearchBarConstraints()
        setupTableViewConstraints()
        setupNoMoviesLabelConstraints()
    }
    
    private func setupSearchBarConstraints() {
        searchBar.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(60)
            make.top.equalTo(view.snp_topMargin)
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { (make) -> Void in
            make.width.bottom.equalTo(view)
            make.top.equalTo(searchBar.snp_bottomMargin)
        }
    }
    
    private func setupNoMoviesLabelConstraints() {
        noMoviesLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.center.equalTo(view)
        }
    }
}

//MARK: - Extensions -
//MARK: - UITableViewDataSource -
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMovieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = currentMovieList[indexPath.row]
        let cell = MoviesTableViewCell.dequeueingReusableCell(in: tableView,
                                                              for: indexPath)
        cell.configure(with: movie)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieID = Int(currentMovieList[indexPath.row].id)
        presenter.moviePosterTapped(with: movieID)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        checkIfUpdateIsNeeded(for: indexPath)
    }
    
    private func checkIfUpdateIsNeeded(for indexPath: IndexPath) {
        guard isCellToLoad(with: indexPath) else { return }
        movieSearchText.isEmpty ? loadMoreResults() : getMoreResultsBySearch()
    }
    
    private func isCellToLoad(with indexPath: IndexPath) -> Bool {
        return indexPath.row == currentMovieList.count - 5
    }
    
    private func loadMoreResults(_ startAgain: Bool = false) {
        presenter.getMovieList(by: movieSortingType, startAgain: startAgain)
    }
    
    private func getMoreResultsBySearch(_ startAgain: Bool = false) {
        presenter.getMovieListBySearch(movieSearchText, startAgain: startAgain)
    }
    
    private func scrollToTop() {
        let topRow = IndexPath(row: 0,
                               section: 0)
        tableView.scrollToRow(at: topRow,
                              at: .top,
                              animated: false)
    }
}

//MARK: - SearchBar Delegate -
extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        let delay = 0
        getSearchResults(query: searchText, deadline: delay)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getSearchResults(query: searchText)
    }
}

//MARK: - ActionSheet -
extension MovieListViewController {
    enum ActionSheetLabel: String {
        case popular = "Самые популярные"
        case revenue = "Cамые прибыльные"
        case famous = "Самые известные"
    }
    
    @objc private func showActionSheetWithSortingType() {
        let title = "Как остортировать фильмы?"
        showActionSheetWithCancel(actions: [
            (ActionSheetLabel.popular.rawValue, { [weak self] in
                self?.sortList(by: Constants.SortType.byPopular)
            }),
            (ActionSheetLabel.revenue.rawValue, { [weak self] in
                self?.sortList(by: Constants.SortType.byRevenue)
            }),
            (ActionSheetLabel.famous.rawValue, { [weak self] in
                self?.sortList(by: Constants.SortType.byAverageCount)
            })
        ], with: title)
    }
    
    private func sortList(by sort: String) {
        showSpinner(spinner)
        clearSearchBar()
        setValuesForCurrentVariables(with: sort)
        presenter.getMovieList(by: sort, startAgain: true)
    }
    
    private func clearSearchBar() {
        searchBar.resignFirstResponder()
        searchBar.text?.removeAll()
    }
    
    private func setValuesForCurrentVariables(with sort: String) {
        movieSortingType = sort
        currentMovieList.removeAll()
        movieSearchText.removeAll()
    }
}

//MARK: - MovieListViewProtocol -
extension MovieListViewController: MovieListViewProtocol {
    func setOnlineMode() {
        showRightBarButton()
    }
    
    func setOfflineMode() {
        let message = "You are offline. Please, enable your Wi-Fi or connect using cellular data."
        showErrorAlert(with: message)
        hideRightBarButton()
    }
    
    func setMovieList(_ moviesArray: [StoredMovieModel]) {
        currentMovieList.append(contentsOf: moviesArray)
        updateMovieList()
    }
    
    func showErrorAlert(with message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(with: "Error", message)
        }
        hideSpinner(spinner)
    }
    
    private func hideRightBarButton() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func showRightBarButton() {
        DispatchQueue.main.async { [weak self] in
            self?.setNavigationBarItems()
        }
    }
    
    private func updateMovieList() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.hideSpinner(strongSelf.spinner)
            strongSelf.tableView.reloadData()
            if strongSelf.currentMovieList.count == 20 {
                strongSelf.scrollToTop()
            }
            
            guard !strongSelf.currentMovieList.isEmpty else {
                strongSelf.setVisibilityForUIElements(isEmpty: true)
                return
            }
            
            if strongSelf.tableView.isHidden {
                strongSelf.setVisibilityForUIElements(isEmpty: false)
            }
        }
    }
    
    private func setVisibilityForUIElements(isEmpty: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = isEmpty
            self?.noMoviesLabel.isHidden = !isEmpty
        }
    }
}



