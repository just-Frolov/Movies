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
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var headerView: UIView = {
        let header = UIView()
        header.addSubview(movieTitleLabel)
        return header
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: 0,
                                              height: 0),
                                style: .grouped)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.allowsSelection = false
        InfoTableViewCell.register(in: table)
        table.register(InfoTableViewSection.self,
                               forHeaderFooterViewReuseIdentifier: InfoTableViewSection.identifier)
        table.isHidden = true
        return table
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    var presenter: MovieInfoViewPresenterProtocol!
    private var movieDetails: MovieDetailsData!
    private var dataSource: [InfoTableSectionModel] = []
    
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
        addTapRecognizerToPoster()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
    }
    
    private func setupPlayerView() {
        playerViewSpinner.startAnimating()
        playerView.delegate = self
    }
    
    private func addTapRecognizerToPoster() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(posterTapped(tapGestureRecognizer:)))
            moviePoster.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func posterTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        guard let poster = tappedImage.image else { return }
        presenter.showPosterInFullScreen(image: poster)
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
        setupHeaderViewConstraints()
        setupMovieTitleLabelConstraints()
        setupTableViewConstraints()
    }
    
    private func setupPlayerViewConstraints() {
        playerView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(250)
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
            make.height.lessThanOrEqualTo(250)
        }
    }
    
    private func setupHeaderViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
        }
    }
    
    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp_bottomMargin).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

//MARK: - Extension -
//MARK: - UITableViewDataSource -
extension MovieInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].cellTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = InfoTableViewCell.dequeueingReusableCell(in: tableView, for: indexPath)
        let cellType = dataSource[indexPath.section].type
        var currentMovieInfo = String()
        //MARK: - TODO
        switch cellType {
        case .genres:
            currentMovieInfo = presenter.createGenreList(by: movieDetails.genres) ?? ""
        case .releaseDate:
            if let safeDate = movieDetails.releaseDate {
                currentMovieInfo = presenter.formatDate(from: safeDate)
            } else {
                currentMovieInfo = "No Info"
            }
        case .rating:
            currentMovieInfo = String(movieDetails.voteAverage)
        case .originalTitle:
            currentMovieInfo = movieDetails.originalTitle
        case .description:
            currentMovieInfo = movieDetails.overview
        case .budget:
            currentMovieInfo = presenter.createDecimalNumber(from: movieDetails.budget)
        case .production:
            currentMovieInfo = movieDetails.productionCountries[0].name
        case .revenue:
            currentMovieInfo = presenter.createDecimalNumber(from: movieDetails.revenue)
        }

        cell.configure(with: currentMovieInfo)
        return cell
    }
}

//MARK: - UITableViewDelegate -
extension MovieInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = dataSource[section].type
        let sectionTitle = sectionType.rawValue
        let section = tableView.dequeueReusableHeaderFooterView(withIdentifier: InfoTableViewSection.identifier) as? InfoTableViewSection
        section?.configure(title: sectionTitle)
        return section
    }
}

//MARK: - MovieInfoViewProtocol -
extension MovieInfoViewController: MovieInfoViewProtocol {
    //MARK: - Internal -
    func setMovieInfo(from movieDetails: MovieDetailsData) {
        setImage(from: movieDetails.backdropPath)
        movieTitleLabel.text = movieDetails.title
        self.movieDetails = movieDetails
    }
    
    func updateSections(_ sections: [InfoTableSectionModel]) {
        dataSource = sections
        tableView.reloadData()
        tableView.isHidden = false
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
    private func setImage(from url: String?) {
        if let poster = url {
            NetworkService.shared.setImage(imageURL: poster,
                                           imageView: self.moviePoster)
        } else {
            self.moviePoster.image = UIImage(named: "noImageFound")
        }
    }
}

//MARK: - YTPlayerViewDelegate -
extension MovieInfoViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerViewSpinner.stopAnimating()
        playerView.isHidden = false
    }
}
