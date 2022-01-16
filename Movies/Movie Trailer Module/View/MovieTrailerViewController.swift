//
//  MovieTrailerViewController.swift
//  Movies
//
//  Created by Данил Фролов on 16.01.2022.
//

import youtube_ios_player_helper
import SnapKit
import JGProgressHUD

class MovieTrailerViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var playerView = YTPlayerView()
    
    private lazy var errorLabel: UILabel = {
            let label = UILabel()
            label.text = "Trailer not found!"
            label.textAlignment = .center
            label.textColor = .white
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.isHidden = true
            return label
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .light)
    
    //MARK: - Variables -
    var presenter: MovieTrailerViewPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        showSpinner(spinner)
        addSubviews()
        setupConstraints()
        setupView()
        presenter.viewDidLoad()
    }
    
    //MARK: - Private -
    private func addSubviews() {
        view.addSubview(playerView)
        view.addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        setupPlayerViewConstraints()
        setupErrorLabelConstraints()
    }
    
    private func setupPlayerViewConstraints() {
        playerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.snp_topMargin)
            make.height.lessThanOrEqualTo(300)
        }
    }
    
    private func setupErrorLabelConstraints() {
            errorLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view)
                make.center.equalTo(view)
            }
    }
    
    private func setupView() {
        title = "Trailer"
        playerView.delegate = self
    }
}

extension MovieTrailerViewController: MovieTrailerViewProtocol {
    func playMovieVideo(with id: String) {
        playerView.load(withVideoId: id)
    }
    
    func showErrorLabel() {
        hideSpinner(spinner)
        playerView.isHidden = true
        errorLabel.isHidden = false
    }
    
    func showError(with message: String) {
        showErrorLabel()
        showAlert("Error", with: message)
    }
}

extension MovieTrailerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        hideSpinner(spinner)
        playerView.playVideo()
    }
}
