//
//  ImageManager.swift
//  Movies
//
//  Created by Данил Фролов on 26.01.2022.
//

import Kingfisher
import Foundation

private struct Constants {
    static let baseURL = "https://image.tmdb.org/t/p"
    static let imageSize = "/w500"
    
    
}

struct ImageManager {
    //MARK: - Static Constants -
    static let shared = ImageManager()
    private static let baseURL = "https://image.tmdb.org/t/p"
    private static let imageSize = "/w500"
    
    //MARK: - Internal
    func fullURL(imageURL: String) -> URL? {
        let stringURL = ImageManager.baseURL + ImageManager.imageSize + imageURL
        return URL(string: stringURL) 
    }
    
    func setImage(mainUrl: URL, imageView: UIImageView) {
        let url = mainUrl
        imageView.kf.setImage(with: url) { result in
            switch result {
            case .failure(_):
                imageView.image = UIImage(named: K.Assets.defaultImageName)
            default:
                break
            }
        }
    }
}
