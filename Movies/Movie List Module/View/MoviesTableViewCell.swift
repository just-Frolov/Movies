//
//  MoviesTableViewCell.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import SnapKit

class MoviesTableViewCell: BaseTableViewCell {
    //MARK: - UI Elements -
    private lazy var movieView: UIView = {
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: contentView.bounds.width,
                                        height: 200))
        view.addSubview(moviePoster)
        view.addSubview(movieTitleLabel)
        view.addSubview(movieRatingView)
        view.addSubview(movieGenresLabel)
        view.addSubview(movieReleaseDataLabel)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 20).cgPath
        return view
    }()
    
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var movieReleaseDataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var movieGenresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var movieRatingView: UIView = {
        let view = UIView()
        view.addSubview(movieRatingLabel)
        view.addSubview(movieRatingIcon)
        return view
    }()
    
    private lazy var movieRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    private lazy var movieRatingIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(systemName: "star.fill")
        image.tintColor = .white
        return image
    }()
    
    //MARK: - Life Cycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    func configure(with model: StoredMovieModel) {
        setMovieInfo(from: model)
        setImage(from: model.poster)
        setMovieGenres(by: model.genreIDS)
    }
    
    //MARK: - Private -
    private func addSubview() {
        contentView.addSubview(movieView)
    }
    
    private func setMovieInfo(from model: StoredMovieModel) {
        movieTitleLabel.text = model.title
        movieReleaseDataLabel.text = model.releaseDate?.replace(target: "-", withString: ".")
        movieRatingLabel.text = String(model.voteAverage)
    }
    
    private func setImage(from link: String?) {
        imageView?.image = nil
        if let poster = link {
            NetworkService.shared.setImage(imageURL: poster, imageView: self.moviePoster)
        } else {
            moviePoster.image = UIImage(named: "noImageFound")
        }
    }
    
    private func setMovieGenres(by genreIDS: [Int]?) {
        guard let safeGenreID = genreIDS else { return }
        var genreList = String()
        var genreName = String()
        for genre in safeGenreID {
            genreName = GenreListConfigurable.shared.getGenreName(id: genre)
            genreList.addingDevidingPrefixIfNeeded()
            genreList += genreName.capitalizingFirstLetter()
        }
        movieGenresLabel.text = genreList
    }
    
    private func setupConstraints() {
        setupMovieViewConstraints()
        setupMoviePosterConstraints()
        setupMovieTitleLabelConstraints()
        setupMovieRatingViewConstraints()
        setupMovieRatingLabelConstraints()
        setupMovieRatingIconConstraints()
        setupMovieReleaseDataLabelConstraints()
        setupMovieGenresLabelConstraints()
    }
    
    private func setupMovieViewConstraints() {
        let marginFromEdges = CGFloat(15)
        movieView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: marginFromEdges,
                                                               left: marginFromEdges,
                                                               bottom: marginFromEdges,
                                                               right: marginFromEdges))
        }
    }
    
    private func setupMoviePosterConstraints() {
        moviePoster.snp.makeConstraints { (make) -> Void in
            make.width.height.lessThanOrEqualToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.snp.makeConstraints { (make) -> Void in
            make.left.bottom.equalToSuperview().inset(20)
            make.right.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    private func setupMovieRatingViewConstraints() {
        movieRatingView.snp.makeConstraints { (make) -> Void in
            make.left.equalToSuperview().inset(20)
            make.bottom.equalTo(movieTitleLabel.snp_topMargin).offset(-10)
        }
    }
    
    private func setupMovieRatingIconConstraints() {
        movieRatingIcon.snp.makeConstraints { (make) -> Void in
            make.left.bottom.equalToSuperview()
            make.width.height.equalTo(13)
        }
    }
    
    private func setupMovieRatingLabelConstraints() {
        movieRatingLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalToSuperview().offset(1)
            make.left.equalTo(movieRatingIcon.snp_rightMargin).offset(12)
        }
    }
    
    private func setupMovieGenresLabelConstraints() {
        movieGenresLabel.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(movieView).inset(20)
            make.top.equalTo(movieView).offset(15)
        }
    }
    
    private func setupMovieReleaseDataLabelConstraints() {
        movieReleaseDataLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(movieView).offset(20)
            make.top.equalTo(movieGenresLabel.snp_bottomMargin).offset(15)
        }
    }
}

