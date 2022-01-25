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
    private lazy var headerView: UIView = {
        let header = UIView()
        header.addSubview(playerView)
        header.addSubview(playerViewSpinner)
        header.addSubview(moviePoster)
        header.addSubview(movieTitleLabel)
        return header
    }()
    
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
        table.isHidden = true
        table.register(InfoTableViewSection.self,
                       forHeaderFooterViewReuseIdentifier: InfoTableViewSection.identifier)
        InfoTableViewCell.register(in: table)
        return table
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    var presenter: MovieInfoViewPresenterProtocol!
    //TODO: - -
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
        view.backgroundColor = .white
        setupNavBar()
        setupTableView()
        setupPlayerView()
        addTapRecognizerToPoster()
    }
    
    private func setupNavBar() {
        title = "Movie Details"
        navigationController?.navigationBar.topItem?.title = "";
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
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        setupHeaderViewConstraints()
        setupPlayerViewConstraints()
        setupPlayerViewSpinnerConstraints()
        setupMoviePosterConstraints()
        setupMovieTitleLabelConstraints()
        setupTableViewConstraints()
    }
    
    private func setupHeaderViewConstraints() {
        headerView.snp.makeConstraints { make in
            make.bottom.equalTo(290)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupPlayerViewConstraints() {
        playerView.snp.makeConstraints { make in
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
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.lessThanOrEqualTo(250)
        }
    }
    
    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(moviePoster.snp_bottomMargin).offset(30)
            make.height.equalTo(25)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
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
        //TODO: -
        switch cellType {
        case .genres:
            currentMovieInfo = presenter.createGenreList(by: movieDetails.genres) ?? ""
        case .releaseDate:
            if let safeDate = movieDetails.releaseDate {
                currentMovieInfo = formatDate(from: safeDate)
            } else {
                currentMovieInfo = "No Info"
            }
        case .rating:
            currentMovieInfo = String(movieDetails.voteAverage)
        case .originalTitle:
            currentMovieInfo = movieDetails.originalTitle
        case .description:
            currentMovieInfo = movieDetails.overview.isEmpty ? "No Info" : movieDetails.overview
        case .budget:
            currentMovieInfo = createDecimalNumber(from: movieDetails.budget)
        case .production:
            currentMovieInfo = movieDetails.productionCountries.first?.name ?? "No Info"
        case .revenue:
            currentMovieInfo = createDecimalNumber(from: movieDetails.revenue)
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
    func setMovieInfo(from movieDetails: MovieDetailsData, with sectionType: [InfoTableSectionModel]) {
        setImage(from: movieDetails.backdropPath)
        movieTitleLabel.text = movieDetails.title
        self.movieDetails = movieDetails
        updateSections(sectionType)
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
    private func updateSections(_ sections: [InfoTableSectionModel]) {
        dataSource = sections
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    private func setImage(from url: String?) {
        if let poster = url {
            NetworkService.shared.setImage(imageURL: poster,
                                           imageView: self.moviePoster)
        } else {
            self.moviePoster.image = UIImage(named: "imageNotFound")
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
