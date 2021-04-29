//
//  ChannelCell.swift
//  newsApp
//
//  Created by Нагоев Магомед on 19.04.2021.
//

import UIKit
import PureLayout
import Kingfisher

class ChannelCell:UITableViewCell {
    static let identifier = "ChannelCell"

    weak var delegate:FavotiteChannelProtocol?

    private var idChannel = String()

    var isFavoriteChannel = Bool()

    private var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.textColor = .black
//        numberLabel.backgroundColor = .lightGray
//        numberLabel.layer.masksToBounds = true
//        numberLabel.layer.cornerRadius = 15
        numberLabel.textAlignment = .center
        numberLabel.font = UIFont.systemFont(ofSize: 16,weight: .bold)
        return numberLabel
    }()

    private var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        return nameLabel
    }()

    private var descriptionLabel:UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        return descriptionLabel
    }()

    private var faviconImage = UIImageView()

    var favoriteButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false

        addSubview(numberLabel)
        numberLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        numberLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        numberLabel.autoSetDimensions(to: CGSize(width: 30, height: 30))

        addSubview(nameLabel)
        nameLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        nameLabel.autoPinEdge(.left, to: .right, of: numberLabel, withOffset: 30)
        nameLabel.autoPinEdge(toSuperviewEdge: .right)

        addSubview(descriptionLabel)
        descriptionLabel.autoPinEdge(.top, to: .bottom, of: nameLabel)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        descriptionLabel.autoPinEdge(.left, to: .right, of: numberLabel, withOffset: 10)
        descriptionLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 50)

        addSubview(faviconImage)
        faviconImage.autoAlignAxis(.horizontal, toSameAxisOf: nameLabel)
        faviconImage.autoPinEdge(.right, to: .left, of: nameLabel, withOffset: -5)

        addSubview(favoriteButton)
        favoriteButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        favoriteButton.autoPinEdge(.left, to: .right, of: descriptionLabel, withOffset: 10)
        favoriteButton.autoSetDimensions(to: CGSize(width: 20, height: 20))

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(name: String, description: String, numberChannel: Int, numberOfLines: Int, id: String) {
        nameLabel.text = name
        descriptionLabel.text = description
        numberLabel.text = String("\(numberChannel+1).")
        descriptionLabel.numberOfLines = numberOfLines
        idChannel = id
    }

    func setFavoriteButton (isFavorite: Bool) {
        isFavoriteChannel = isFavorite
        editImageFavoriteButton()
        favoriteButton.isSelected = isFavorite
        favoriteButton.addTarget(self, action: #selector(onFavoriteTapped), for: .touchUpInside)
    }

    func addImageUrl (url:String) {
        let newUrl = cleanUrl(url: url)
        let urlImage = URL(string: "https://www.google.com/s2/favicons?domain=\(newUrl)")
        faviconImage.kf.setImage(with: urlImage)
    }

    func addImageDB(imageData: Data?) {
        guard let imageData = imageData else { return }
        let image = UIImage(data: imageData)
        faviconImage.image = image
    }

    func cleanUrl(url: String) -> String {
        let firstIndex = url.index(url.firstIndex(of: "/")!, offsetBy: 2)

        var newUrl = url[firstIndex...]
        if newUrl.contains("/") {
            let lastIndex = newUrl.firstIndex(of: "/") ?? newUrl.endIndex
            newUrl = newUrl[..<lastIndex]
        }
        return String(newUrl)
    }

    func editImageFavoriteButton () {
        var imageCircle = UIImage()
        var imageCheck = UIImage()
        if #available(iOS 13.0, *) {
            let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold, scale: .large)
            imageCircle = (UIImage(systemName: "circle",
                                   withConfiguration:
                                    configuration)?.withTintColor(.gray,renderingMode: .alwaysOriginal))!
            imageCheck = (UIImage(systemName: "checkmark.circle",
                                  withConfiguration:
                                    configuration)?.withTintColor(.gray,renderingMode: .alwaysOriginal))!
        } else {
            imageCircle = UIImage(named: "circle")!
            imageCheck = UIImage(named: "check")!
        }
        favoriteButton.setImage(imageCircle, for: .normal)
        favoriteButton.setImage(imageCheck, for: .selected)
    }

//    func actionFavoriteButton (isFavoriteButton: Bool) {
//        if isFavoriteButton {
//            favoriteButton.addTarget(self, action: #selector(deleteFavChan), for: .touchUpInside)
//        } else {
//            favoriteButton.addTarget(self, action: #selector(addFavChan), for: .touchUpInside)
//        }
//    }

    @objc func addFavChan() {
        print("Постер в фаворите \(idChannel)")
        StorageManager.saveObject(name: nameLabel.text!,
                                  descriptionChannel: descriptionLabel.text!,
                                  image: faviconImage, channelId: idChannel)
        delegate?.reloadTableview()
        isFavoriteChannel = true
    }

    @objc func deleteFavChan() {
        print("Удалить \(idChannel)")
        StorageManager.deleteObject(id: idChannel)
        delegate?.reloadTableview()
        isFavoriteChannel = false
    }

    @objc func onFavoriteTapped() {
        if isFavoriteChannel {
            StorageManager.deleteObject(id: idChannel)
        } else {
            StorageManager.saveObject(name: nameLabel.text!,
                                      descriptionChannel: descriptionLabel.text!,
                                      image: faviconImage, channelId: idChannel)
        }
        isFavoriteChannel = !isFavoriteChannel
        favoriteButton.isSelected = isFavoriteChannel
        delegate?.reloadTableview()
    }
}
