//
//  MovieInfoViewController.swift
//  Movies
//
//  Created by Данил Фролов on 14.01.2022.
//

import SnapKit
import JGProgressHUD
import youtube_ios_player_helper

class MovieInfoViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var playerView: YTPlayerView = {
        let player = YTPlayerView()
        player.isHidden = true
        return player
    }()
    
    private lazy var playerViewSpinner = UIActivityIndicatorView(style: .medium)
    
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        return image
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.allowsSelection = false
        InfoTableViewCell.register(in: table)
        table.register(InfoTableViewHeader.self,
                       forHeaderFooterViewReuseIdentifier: InfoTableViewHeader.identifier)
        return table
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    var presenter: MovieInfoViewPresenterProtocol!
    private var movieTitle = String()
    private var movieInfo = [String: String]()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupView()
        addSubViews()
        setupConstraints()
    }
    
    //MARK: - Private -
    private func setupView() {
        title = "Movie Details"
        navigationController?.navigationBar.topItem?.title = " ";
        view.backgroundColor = .white
        setupTableView()
        setupPlayerView()
    }
    
    private func setupTableView() {
        showSpinner(spinner)
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupPlayerView() {
        playerViewSpinner.startAnimating()
        playerView.delegate = self
    }
    
    private func addSubViews() {
        view.addSubview(playerView)
        view.addSubview(playerViewSpinner)
        view.addSubview(moviePoster)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        setupPlayerViewConstraints()
        setupPlayerViewSpinnerConstraints()
        setupMoviePosterConstraints()
        setupTableViewConstraints()
    }
    
    private func setupPlayerViewConstraints() {
        playerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(200)
        }
    }
    
    private func setupPlayerViewSpinnerConstraints() {
        playerViewSpinner.snp.makeConstraints { make in
            make.center.equalTo(playerView)
        }
    }
    
    private func setupMoviePosterConstraints() {
        moviePoster.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(200)
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp_bottomMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

//MARK: - Extension -
//MARK: - UITableViewDataSource -
extension MovieInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let key = TableViewCellType.allCases[indexPath.row].rawValue
        let value = movieInfo[key] ?? "No Info"
        let cell = InfoTableViewCell.dequeueingReusableCell(in: tableView, for: indexPath)
        cell.configure(header: key, text: value)
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension MovieInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: InfoTableViewHeader.identifier) as? InfoTableViewHeader
        header?.configure(title: movieTitle)
        return header
    }
}

//MARK: - MovieInfoViewProtocol -
extension MovieInfoViewController: MovieInfoViewProtocol {
    //MARK: - Internal -
    func setMovieInfo(_ model: MovieDetailsData) {
            setImage(from: model.backdropPath)
            setMovieDetails(from: model)
            showTableView()
            hideSpinner(spinner)
    }
    
    func showMoviePoster() {
        playerViewSpinner.stopAnimating()
        moviePoster.isHidden = false
    }
    
    func showMovieVideo(with id: String) {
        playerView.load(withVideoId: id)
    }
    
    func showErrorAlert(with message: String) {
        showAlert("Error", with: message)
    }
    
    //MARK: - Private -
    private func showTableView() {
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    private func setImage(from url: String?) {
        if let poster = url {
            NetworkService.shared.setImage(imageURL: poster,
                                           imageView: self.moviePoster)
        } else {
            self.moviePoster.image = UIImage(named: "noImageFound")
        }
    }
    
    private func setMovieDetails(from model: MovieDetailsData) {
        let movieGenres = createGenreList(by: model.genres) ?? "No Info"
        let movieBudget = createDecimalNumber(from: model.budget) ?? "No Info"
        movieTitle = model.title
        movieInfo[TableViewCellType.genres.rawValue] = movieGenres
        movieInfo[TableViewCellType.description.rawValue] = model.overview
        movieInfo[TableViewCellType.rating.rawValue] = String(model.voteAverage)
        movieInfo[TableViewCellType.originalTitle.rawValue] = model.originalTitle
        movieInfo[TableViewCellType.releaseDate.rawValue] = model.releaseDate
        movieInfo[TableViewCellType.production.rawValue] = model.productionCountries[0].name
        movieInfo[TableViewCellType.budget.rawValue] = movieBudget
    }
    
    private func createGenreList(by genreArray: [DataName]) -> String? {
        var genreList = String()
        for genre in genreArray {
            genreList.addingDevidingPrefixIfNeeded()
            genreList += genre.name.capitalizingFirstLetter()
        }
        return genreList
    }
    
    private func createDecimalNumber(from largeNumber: Int) -> String? {
        guard largeNumber != 0 else {
            return nil
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber))
        return formattedNumber
    }
}

//MARK: - YTPlayerViewDelegate -
extension MovieInfoViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerViewSpinner.stopAnimating()
        playerView.isHidden = false
    }
}
