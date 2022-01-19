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
    private lazy var playerView = YTPlayerView()
    
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.isHidden = true
        return image
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        InfoTableViewCell.register(in: table)
        return table
    }()
    
    private lazy var tableViewHeader: UIView = {
        let header = UIView()
        header.addSubview(movieTitleLabel)
        return header
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .light)
    
    //MARK: - Variables -
    var presenter: MovieInfoViewPresenterProtocol!
    private var movieInfo = [String: String]()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    //MARK: - Private -
    private func setupView() {
        title = "Movie Details"
        navigationController?.navigationBar.topItem?.title = " ";
        view.backgroundColor = .white
        showSpinner(spinner)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func addSubViews() {
        view.addSubview(playerView)
        view.addSubview(moviePoster)
        view.addSubview(tableView)
        view.addSubview(tableViewHeader)
    }
    
    private func setupConstraints() {
        setupPlayerViewConstraints()
        setupMoviePosterConstraints()
        setupTableViewConstraints()
        setupTableViewHeaderConstraints()
        setupMovieTitleLabelConstraints()
    }
    
    private func setupPlayerViewConstraints() {
        playerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(200)
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
    
    private func setupTableViewHeaderConstraints() {
        tableViewHeader.snp.makeConstraints { make in
            make.width.equalTo(tableView)
            make.height.equalTo(60)
        }
    }
    
    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().offset(-40)
            make.height.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20).priority(.required)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableViewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

//MARK: - MovieInfoViewProtocol -
extension MovieInfoViewController: MovieInfoViewProtocol {
    //MARK: - Internal -
    func setMovieInfo(_ model: MovieDetailsData) {
        setImage(from: model.backdropPath)
        setMovieDetails(from: model)
        hideSpinner(self.spinner)
        tableView.reloadData()
    }
    
    func showMoviePoster() {
        moviePoster.isHidden = false
        playerView.isHidden = true
    }
    
    func showMovieVideo(with id: String) {
        playerView.load(withVideoId: id)
    }
    
    func showErrorAlert(with message: String) {
        showAlert("Error", with: message)
    }
    
    //MARK: - Private -
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
        movieTitleLabel.text = model.title
        movieInfo[TableViewCellType.genres.rawValue] = movieGenres
        movieInfo[TableViewCellType.description.rawValue] = model.overview
        movieInfo[TableViewCellType.rating.rawValue] = String(model.voteAverage)
        movieInfo[TableViewCellType.originalTitle.rawValue] = model.originalTitle
        movieInfo[TableViewCellType.releaseDate.rawValue] = model.releaseDate
        movieInfo[TableViewCellType.production.rawValue] = model.productionCountries[0].name
        movieInfo[TableViewCellType.budget.rawValue] = movieBudget
    }
    
    private func createGenreList(by genreArray: [Genre]) -> String? {
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
