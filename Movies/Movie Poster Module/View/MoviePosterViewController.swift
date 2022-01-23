//
//  MoviePosterViewController.swift
//  Movies
//
//  Created by Данил Фролов on 21.01.2022.
//

import SnapKit
import UIKit


class MoviePosterViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.frame = CGRect(x: 0,
                                   y: 0,
                                   width: 200,
                                   height: 100)
        image.center = view.center
        return image
    }()
    
    //MARK: - Variables -
    var presenter: MoviePosterViewPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Poster"
        addSubview()
        //setupMoviePosterConstraints()
        addGesture()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        moviePoster.isHidden = true
    }
    
    //MARK: - Private -
    private func addSubview() {
        view.addSubview(moviePoster)
    }
    
    private func setupMoviePosterConstraints(with scale: CGFloat = 1) {
        moviePoster.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(scale)
            make.center.equalToSuperview()
        }
    }
    
    private func addGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(didPinch(_:)))
        moviePoster.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func didPinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            let scale = gesture.scale
            print(scale)
            moviePoster.frame = CGRect(x: 0,
                                       y: 0,
                                       width: 200*scale,
                                       height: 100*scale)
            moviePoster.center = view.center
        }
    }
}

extension MoviePosterViewController: MoviePosterViewProtocol {
    func showPoster(image: UIImage) {
        moviePoster.image = image
    }
}
