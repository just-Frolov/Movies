//
//  MoviePosterViewController.swift
//  Movies
//
//  Created by Данил Фролов on 21.01.2022.
//

import SnapKit

class MoviePosterViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.addSubview(moviePoster)
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.frame = CGRect(x: 0,
                             y: 0,
                             width: view.frame.size.width,
                             height: view.frame.size.width/1.5)
        image.center = view.center
        return image
    }()
    
    private lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self,
                                                action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
    //MARK: - Variables -
    var presenter: MoviePosterViewPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Poster"
        addSubview()
        setupConstraints()
        setupScrollView()
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        centerImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        moviePoster.isHidden = true
    }
    
    //MARK: - Private -
    private func addSubview() {
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        setupScrollViewConstraints()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    private func centerImage() {
        let viewSize = view.bounds.size
        var frameToCenter = moviePoster.frame
        
        if frameToCenter.size.width < viewSize.width {
            frameToCenter.origin.x = (viewSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < viewSize.height {
            frameToCenter.origin.y = (viewSize.height - frameToCenter.size.height) / 3
        } else {
            frameToCenter.origin.y = 0
        }
        
        moviePoster.frame = frameToCenter
    }
    
    @objc private func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }
    
    private func zoom(point: CGPoint, animated: Bool) {
        let currentScale = scrollView.zoomScale
        let minScale = scrollView.minimumZoomScale
        let maxScale = scrollView.maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        
        let toScale = maxScale
        let finalScale = (currentScale == minScale) ? toScale : minScale
        let zoomRect = zoomRect(scale: finalScale, center: point)
        scrollView.zoom(to: zoomRect, animated: true)
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = scrollView.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
}

//MARK: - UIScrollViewDelegate -
extension MoviePosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.moviePoster
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}

//MARK: - MoviePosterViewProtocol -
extension MoviePosterViewController: MoviePosterViewProtocol {
    func showPoster(image: UIImage) {
        moviePoster.image = image
        configurateFor(imageSize: image.size)
    }
    
    private func configurateFor(imageSize: CGSize) {
        scrollView.contentSize = imageSize
        scrollView.maximumZoomScale = 3
        moviePoster.addGestureRecognizer(zoomingTap)
    }
}
