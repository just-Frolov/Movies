//
//  ViewController.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import SnapKit
import JGProgressHUD
import Dispatch

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
    private var currentMovieList = [Movie]()
    private var initialScrollTableViewHeight: CGFloat = 0.0
    private var currentMaxScrollTableViewHeight: CGFloat = 0.0
    private var movieSearchText = String()
    private var movieSortingType = SortType.byPopular.rawValue
    private var workItem: DispatchWorkItem?
    
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
        createTitle()
    }
    
    //MARK: - Private -
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        setupSearchBar()
    }
    
    private func setupNavigationBar() {
        configureItems()
        setupNavigationBarAppearence()
    }
    
    private func createTitle() {
        title = "Popular Movies"
    }
    
    private func configureItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down.square"),
            style: .done,
            target: self,
            action: #selector(showSortingActionSheet)
        )
    }

    private func setupNavigationBarAppearence() {
        let navAppearance = UINavigationBarAppearance()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
        navigationController?.navigationBar.standardAppearance = navAppearance
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
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
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieID = currentMovieList[indexPath.row].id
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.tapOnTheMovie(with: movieID)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let cellHeight = CGFloat(250)
        let loadingMark = cellHeight * 3
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        
        if (offsetY > contentHeight - loadingMark && offsetY > currentMaxScrollTableViewHeight - loadingMark) {
            changeTableViewValues(contentHeight)
            movieSearchText.isEmpty ? getNewMovies() : getNewMoviesBySearch()
        }
    }
    
    private func changeTableViewValues(_ contentHeight: CGFloat) {
        if initialScrollTableViewHeight == 0 {
            initialScrollTableViewHeight = contentHeight
        }
        currentMaxScrollTableViewHeight = contentHeight + initialScrollTableViewHeight
    }
    
    private func resetCurrentTableViewHeight() {
        currentMaxScrollTableViewHeight = 0.0
    }
    
    private func getNewMovies(_ startAgain: Bool = false) {
        presenter.getMovieList(by: movieSortingType, startAgain: startAgain)
    }
    
    private func getNewMoviesBySearch(_ startAgain: Bool = false) {
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
    
    private func getSearchResults(query: String, deadline: Int = 500) {
        workItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.startMovieSearchRequest(with: query)
        }
        workItem = newWorkItem
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(deadline),
                                          execute: newWorkItem)
    }
    
    private func startMovieSearchRequest(with text: String) {
        currentMovieList.removeAll()
        movieSearchText = text
        if text.replacingOccurrences(of: " ", with: "").isEmpty {
            getNewMovies(true)
            DispatchQueue.main.async { [weak self] in
                self?.view.endEditing(true)
            }
        } else {
            getNewMoviesBySearch(true)
        }
    }
}

//MARK: - ActionSheet -
extension MovieListViewController {
    public enum SortType: String {
        case byPopular = "popularity.desc"
        case byRevenue = "revenue.desc"
        case byAverageCount = "vote_count.desc"
    }
    
    @objc private func showSortingActionSheet() {
        let alert = UIAlertController(title: "Как остортировать фильмы?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Самые популярные",
                                      style: .default,
                                      handler: { _ in
            self.sortList(by: SortType.byPopular.rawValue)
        }))
        alert.addAction(UIAlertAction(title: "Cамые прибыльные",
                                      style: .default,
                                      handler: { _ in
            self.sortList(by: SortType.byRevenue.rawValue)
        }))
        alert.addAction(UIAlertAction(title: "Самые известные",
                                      style: .default,
                                      handler: { _ in
            self.sortList(by: SortType.byAverageCount.rawValue)
        }))
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func sortList(by sort: String) {
        showSpinner(spinner)
        clearSearchBar()
        setValuesForCurrentVariables(with: sort)
        resetCurrentTableViewHeight()
        presenter.getMovieList(by: sort, startAgain: true)
    }
    
    private func clearSearchBar() {
        searchBar.resignFirstResponder()
        searchBar.text?.removeAll()
    }
    
    private func setValuesForCurrentVariables(with sort: String) {
        currentMovieList.removeAll()
        movieSortingType = sort
        movieSearchText.removeAll()
    }
}

//MARK: - MovieListViewProtocol -
extension MovieListViewController: MovieListViewProtocol {
    func setMovieList(_ moviesArray: [Movie]) {
        self.currentMovieList.append(contentsOf: moviesArray)
        updateMovieList()
    }
    
    func showErrorAlert(with message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert("Error", with: message)
        }
        if spinner.isVisible {
            hideSpinner(spinner)
        }
    }
    
    func searchDesiredMoviesLocally() {
        //currentMovieList = lastMovieList.filter { $0.title.lowercased().hasPrefix(movieSearchText.lowercased()) }
        updateMovieList()
    }
    
    private func updateMovieList() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.hideSpinner(strongSelf.spinner)
            strongSelf.tableView.reloadData()
            if strongSelf.currentMovieList.count == 20 {
                strongSelf.scrollToTop()
            }
        }
        
        guard !currentMovieList.isEmpty else {
            tableView.isHidden = true
            noMoviesLabel.isHidden = false
            return
        }
        
        if tableView.isHidden {
            tableView.isHidden = false
            noMoviesLabel.isHidden = true
        }
    }
}




