//
//  File.swift
//  newsApp
//
//  Created by Нагоев Магомед on 25.04.2021.
//

import UIKit
import PureLayout
import Kingfisher

class NewsCell: UITableViewCell {
    static let identifier = "NewsCell"

    private var newsImage:UIImageView = {
        let newsImage = UIImageView()
        newsImage.layer.masksToBounds = true
        newsImage.layer.cornerRadius = 10

        return newsImage
    }()
    private var newsTitleLabel: UILabel = {
       let newsTitleLabel = UILabel()
        newsTitleLabel.textColor = .white
        newsTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return newsTitleLabel
    }()

    private var nameChannelLabel: UILabel = {
       let newsTitleLabel = UILabel()
        newsTitleLabel.textColor = .darkGray
        newsTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return newsTitleLabel
    }()

    private var newsDescriprionLabel:UILabel = {
        let newsDescriprionLabel = UILabel()
        newsDescriprionLabel.numberOfLines = 2
        newsDescriprionLabel.textColor = .white
        newsDescriprionLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return newsDescriprionLabel
    }()

    private var darkenImage: UIImageView = {
        let darkenImage = UIImageView()
        darkenImage.backgroundColor = .black
        darkenImage.layer.opacity = 0.5
        darkenImage.layer.masksToBounds = true
        darkenImage.layer.cornerRadius = 10
        return darkenImage
    }()

    private var faviconImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        addSubview(newsImage)
        newsImage.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        newsImage.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        newsImage.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0)
        newsImage.autoPinEdge(toSuperviewEdge: .top, withInset: 34)

        addSubview(faviconImage)
        faviconImage.autoPinEdge(.bottom, to: .top, of: newsImage, withOffset: -5)
        faviconImage.autoPinEdge(.left, to: .left, of: newsImage, withOffset: 2)

        addSubview(nameChannelLabel)
        nameChannelLabel.autoPinEdge(.bottom, to: .top, of: newsImage, withOffset: -2)
        nameChannelLabel.autoPinEdge(.left, to: .right, of: faviconImage, withOffset: 5)
//        nameChannelLabel.autoPinEdge(.right, to: .right, of: newsImage, withOffset: -5)

        addSubview(darkenImage)
        darkenImage.autoPinEdge(.top, to: .bottom, of: newsImage, withOffset: -60)
        darkenImage.autoPinEdge(.left, to: .left, of: newsImage)
        darkenImage.autoPinEdge(.right, to: .right, of: newsImage)
        darkenImage.autoPinEdge(.bottom, to: .bottom, of: newsImage)

        addSubview(newsTitleLabel)
        newsTitleLabel.autoPinEdge(.top, to: .top, of: darkenImage, withOffset: 5)
        newsTitleLabel.autoPinEdge(.left, to: .left, of: darkenImage, withOffset: 5)
        newsTitleLabel.autoPinEdge(.right, to: .right, of: darkenImage, withOffset: -5)

        addSubview(newsDescriprionLabel)
        newsDescriprionLabel.autoPinEdge(.top, to: .bottom, of: newsTitleLabel, withOffset: 8)
        newsDescriprionLabel.autoPinEdge(.left, to: .left, of: darkenImage, withOffset: 5)
        newsDescriprionLabel.autoPinEdge(.right, to: .right, of: darkenImage, withOffset: -20)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(titleNews: String,
             descriptionNews: String,
             imageUrlString: String,
             nameChannel: String,
             channelImage: Data) {

        guard let url = URL(string: imageUrlString) else { return }

        newsTitleLabel.text = titleNews

        newsDescriprionLabel.text = descriptionNews

        newsImage.kf.setImage(with: url)

        nameChannelLabel.text = nameChannel

        faviconImage.image = UIImage(data: channelImage)

    }
    func addImageUrl (url:String) {
        let newUrl = cleanUrl(url: url)
        let urlImage = URL(string: "https://www.google.com/s2/favicons?domain=\(newUrl)")
        faviconImage.kf.setImage(with: urlImage)
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
}
