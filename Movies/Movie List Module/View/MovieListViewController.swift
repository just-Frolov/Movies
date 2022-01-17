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
    private var movies: [Movie] = []
    private var initialScrollTableViewHeight: CGFloat = 0.0
    private var currentMaxScrollTableViewHeight: CGFloat = 0.0
    private var movieSearchText = ""
    private var movieSort = "Popular"
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubViews()
        setupConstraints()
        setupView()
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
        createTitle()
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
    
    @objc private func showSortingActionSheet() {
        let alert = UIAlertController(title: "Sort The Movies", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "By Popularity",
                                      style: .default,
                                      handler: { _ in
            self.sortList(by: "Popular")
        }))
        alert.addAction(UIAlertAction(title: "By Average Vote",
                                      style: .default,
                                      handler: { _ in
            self.sortList(by: "AverageVote")
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func sortList(by sort: String) {
        showSpinner(self.spinner)
        movieSort = sort
        movies.removeAll()
        presenter.getMovieList(by: sort, startAgain: true)
    }
    
    private func setupNavigationBarAppearence() {
        let navAppearance = UINavigationBarAppearance()
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
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = MoviesTableViewCell.dequeueingReusableCell(in: tableView, for: indexPath)
        cell.configure(with: movie)
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieID = movies[indexPath.row].id
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.tapOnTheMovie(with: movieID)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/3
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let cellHeight = CGFloat(230)
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        
        if (offsetY > contentHeight - cellHeight*3 && offsetY > currentMaxScrollTableViewHeight - cellHeight*3) {
            print("time reload")
            changeTableViewValues(scrollView)
            movieSearchText != "" ? getNewMoviesBySearch() : getNewMovies()
        }
    }
    
    private func changeTableViewValues(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        if initialScrollTableViewHeight == 0 {
            initialScrollTableViewHeight = contentHeight
        }
        currentMaxScrollTableViewHeight = contentHeight + initialScrollTableViewHeight
    }
    
    private func getNewMovies() {
        presenter.getMovieList(by: movieSort, startAgain: false)
    }
    
    private func getNewMoviesBySearch() {
        presenter.getMovieListBySearch(movieSearchText, startAgain: false)
    }
}

//MARK: - SearchBar Delegate
extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        showSpinner(spinner)
        movies.removeAll()
        resetTableViewValues()
        guard let text = searchBar.text?.capitalized, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            movieSearchText = ""
            presenter.getMovieList(by: movieSort, startAgain: true)
            return
        }
        movieSearchText = text
        presenter.getMovieListBySearch(text, startAgain: true)
    }
    
    private func resetTableViewValues() {
        currentMaxScrollTableViewHeight = 0.0
    }
}

//MARK: - MovieListViewProtocol -
extension MovieListViewController: MovieListViewProtocol {
    func setMovieList(_ moviesArray: [Movie]) {
        self.movies += moviesArray
        updateList()
    }

    func updateList() {
        DispatchQueue.main.async {
            self.hideSpinner(self.spinner)
            self.tableView.reloadData()
        }
        
        guard !movies.isEmpty else {
            tableView.isHidden = true
            noMoviesLabel.isHidden = false
            return
        }
        
        if tableView.isHidden {
            tableView.isHidden = false
            noMoviesLabel.isHidden = true
        }
    }
    
    func showErrorAlert(with message: String) {
        DispatchQueue.main.async {
            self.showAlert("Error", with: message)
        }
    }
}




