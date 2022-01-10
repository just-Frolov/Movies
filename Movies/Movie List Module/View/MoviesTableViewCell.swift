//
//  MoviesTableViewCell.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import Kingfisher
import SnapKit

class MoviesTableViewCell: BaseTableViewCell {
    //MARK: - UI Elements -
    private lazy var placeIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemMint
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var placeAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var ratingAndOpenInfoView: UIView = {
        let view = UIView()
        view.addSubview(placeIsOpenLabel)
        view.addSubview(placeRatingLabel)
        return view
    }()

    private lazy var placeIsOpenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var placeRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    //MARK: - Life Cycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private -
    private func addSubviews() {
        contentView.addSubview(placeIcon)
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(placeAddressLabel)
        contentView.addSubview(ratingAndOpenInfoView)
    }
    
    private func setupConstraints() {
        setupPlaceIconConstraints()
        setupPlaceNameLabelConstraints()
        setupPlaceAddressLabelConstraints()
        setupRatingAndOpenInfoViewConstraints()
        setupPlaceIsOpenLabelConstraints()
        setupPlaceRatingLabelConstraints()
    }
    
    private func setupPlaceIconConstraints() {
        placeIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(40)
            make.left.equalTo(10)
            make.centerY.equalTo(contentView.snp_centerYWithinMargins)
        }
    }
    
    private func setupPlaceNameLabelConstraints() {
        placeNameLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 10,
                                                               left: 60,
                                                               bottom: 50,
                                                               right: 5))
        }
    }
    
    private func setupPlaceAddressLabelConstraints() {
        placeAddressLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 40,
                                                               left: 60,
                                                               bottom: 20,
                                                               right: 5))
        }
    }
    
    private func setupRatingAndOpenInfoViewConstraints() {
        ratingAndOpenInfoView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 60,
                                                               left: 60,
                                                               bottom: 0,
                                                               right: 5))
        }
    }
    
    private func setupPlaceIsOpenLabelConstraints() {
        placeIsOpenLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(ratingAndOpenInfoView)
            make.right.equalTo(ratingAndOpenInfoView.snp_centerXWithinMargins)
            make.height.equalTo(ratingAndOpenInfoView)
        }
    }
    
    private func setupPlaceRatingLabelConstraints() {
        placeRatingLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(ratingAndOpenInfoView.snp_centerXWithinMargins)
            make.right.equalTo(ratingAndOpenInfoView)
            make.height.equalTo(ratingAndOpenInfoView)
        }
    }
    
    //MARK: - Internal -
//    func configure(with model: Place) {
//        imageView?.image = nil
//        placeNameLabel.text = model.name
//        placeAddressLabel.text = model.vicinity
//        placeRatingLabel.text = String(model.rating ?? 0)
//
//        let url = URL(string: model.icon)
//        placeIcon.kf.setImage(with: url)
//
//        guard let isOpen = model.openingHours else {
//            placeIsOpenLabel.text = "No Information"
//            return
//        }
//
//        placeIsOpenLabel.text = isOpen.openNow ?  "Open" : "Close"
 //   }
}

