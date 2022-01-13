//
//  MoviesTableViewCell.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import SnapKit
import UIKit

class MoviesTableViewCell: BaseTableViewCell {
    //MARK: - UI Elements -
    private lazy var movieView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(moviePoster)
        view.addSubview(movieTitleLabel)
        view.addSubview(movieRatingView)
        view.addSubview(movieGenresBackgroundView)
        view.addSubview(movieDataBackgroundView)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        view.layer.shadowRadius = 3.0
        view.layer.shadowOpacity = 0.15
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var movieDataBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        view.addSubview(movieReleaseDataLabel)
        return view
    }()
    
    private lazy var movieReleaseDataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var movieGenresBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        view.addSubview(movieGenresLabel)
        return view
    }()
    
    private lazy var movieGenresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
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
    func configure(with model: Movie) {
        imageView?.image = nil
        movieTitleLabel.text = model.title
        movieReleaseDataLabel.text = model.releaseDate
        movieGenresLabel.text = "\(model.genreIDS)"
        movieRatingLabel.text = String(model.voteAverage)
        
        if let poster = model.backdropPath {
            NetworkService.shared.setImage(imageURL: poster, imageView: moviePoster)
        } else {
            //imageView?.image = 
        }
    }
    
    //MARK: - Private -
    private func addSubview() {
        contentView.addSubview(movieView)
    }
    
    private func setupConstraints() {
        setupMovieViewConstraints()
        setupMoviePosterConstraints()
        setupMovieTitleLabelConstraints()
        setupMovieRatingViewConstraints()
        setupMovieRatingLabelConstraints()
        setupMovieRatingIconConstraints()
        setupMovieDataBackgroundViewConstraints()
        setupMovieReleaseDataLabelConstraints()
        setupMovieGenresLabelConstraints()
        setupMovieGenresBackgroundViewConstraints()
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
    
    
    private func setupMovieDataBackgroundViewConstraints() {
        movieDataBackgroundView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(movieReleaseDataLabel).offset(-3)
            make.right.bottom.equalTo(movieReleaseDataLabel).offset(3)
        }
    }
    
    private func setupMovieReleaseDataLabelConstraints() {
        movieReleaseDataLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(movieView).offset(20)
        }
    }
    
    private func setupMovieGenresBackgroundViewConstraints() {
        movieGenresBackgroundView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(movieGenresLabel).offset(-3)
            make.right.bottom.equalTo(movieGenresLabel).offset(3)
        }
    }
    
    private func setupMovieGenresLabelConstraints() {
        movieGenresLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(movieView).offset(20)
            make.top.equalTo(movieReleaseDataLabel.snp_bottomMargin).offset(20)
        }
    }
}

