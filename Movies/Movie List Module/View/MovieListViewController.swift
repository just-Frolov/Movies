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
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    var presenter: MoviesListPresenter!
    private var movies: [Movie] = []
    private var initialScrollTableViewHeight: CGFloat = 0.0
    private var currentMaxScrollTableViewHeight: CGFloat = 0.0
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubViews()
        setupConstraints()
        setupView()
        presenter.viewDidLoad()
    }
    
    //MARK: - Private -
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        setupSearchBar()
    }
    
    private func setupNavigationBar() {
        title = "Movies"
        setupNavigationBarAppearence()
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
        navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
        navigationController?.navigationBar.standardAppearance = navAppearance
    }
    
    private func addSubViews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        setupSearchBarConstraints()
        setupTableViewConstraints()
    }
    
    private func setupSearchBarConstraints() {
        searchBar.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(60)
            make.top.equalTo(view).offset(90)
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { (make) -> Void in
            make.width.bottom.equalTo(view)
            make.top.equalTo(searchBar.snp_bottomMargin)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/3
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let cellHeight = CGFloat(230)
        let contentHeight = scrollView.contentSize.height - scrollView.frame.height
        
        if (offsetY > contentHeight - cellHeight && offsetY > currentMaxScrollTableViewHeight - cellHeight) {
            changeTableViewValues(scrollView)
            getNewMovies()
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
        presenter.getMovies()
    }
}

//MARK: - MovieListViewProtocol -
extension MovieListViewController: MovieListViewProtocol {
    func setMovies(_ moviesArray: [Movie]) {
        movies += moviesArray
        tableView.reloadData()
    }
    
    func showErrorAlert(with message: String) {
        showAlert("Error", with: message)
    }
}


//MARK: - SearchBar Delegate
extension MovieListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
//
//        searchBar.resignFirstResponder()
//
//        results.removeAll()
//        spinner.show(in: view)
//
//        searchUsers(query: text)
//    }
//
//    func searchUsers(query: String) {
//        //check if array has firebase result
//        if !hasFetched {
//            //if not: fetch then filter
//            DatabaseManager.shared.getAllUsers { [weak self] result in
//                switch result {
//                case .failure(let error):
//                    print("Failed to get users: \(error)")
//                    return
//                case .success(let usersCollection):
//                    self?.users = usersCollection
//                    self?.hasFetched = true
//                    self?.filterUsers(with: query)
//                }
//            }
//        }
//        else {
//            filterUsers(with: query)
//        }
//    }
//
//    func filterUsers(with term: String) {
//        // Update the UI: either show result or show no result label
//        guard hasFetched else {
//            return
//        }
//
//        self.spinner.dismiss(animated: true)
//
//        let results: [[String: String]] = self.users.filter({
//            guard let name = $0["name"]?.lowercased() else { return false }
//
//            return name.hasPrefix(term.lowercased())
//        })
//
//        self.results = results
//
//        updateUI()
//    }
//
//    func updateUI() {
//        if results.isEmpty {
//            self.noResultsLabel.isHidden = false
//            self.tableView.isHidden = true
//        }
//        else {
//            self.noResultsLabel.isHidden = true
//            self.tableView.isHidden = false
//            self.tableView.reloadData()
//        }
//    }
}


