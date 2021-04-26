//
//  FavoriteNewsViewController.swift
//  newsApp
//
//  Created by Нагоев Магомед on 24.04.2021.
//

import UIKit
import RealmSwift
import PureLayout

class FavoriteNewsViewController: UIViewController {

    private var articles = [News]()

    private let api = "8932dc51ea5f49c8b078c3063fffe07e"

    private var favoriteChannels: Results<FavoriteChannel>!

    private var numberChannel = 0

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteChannels = realm?.objects(FavoriteChannel.self)

        configureUI()

        getData1(times: 3)
    }

    func getData1(times: Int) {

        var url = "https://newsapi.org/v2/everything?sources="
        if times < favoriteChannels.count - numberChannel {
            print("Загрузить \(times)")
            for _ in 0..<times {
                if let channelId = favoriteChannels[numberChannel].channelId {
                    url += "\(channelId),"
                    numberChannel += 1
                }
            }
        } else {
            print("Загрузить \(favoriteChannels.count - numberChannel)")
            for _ in 0..<favoriteChannels.count - numberChannel {
                if let channelId = favoriteChannels[numberChannel].channelId {
                    url += "\(channelId),"
                    numberChannel += 1
                }
            }
        }
//        print(numberChannel)
//        print(favoriteChannels.count - numberChannel)
        url += "&apiKey=\(api)"
        NetworkManager.fetchData(url: url, model: Articles()) {(articles) in
            guard let news = articles.articles else { return }
            self.articles += news
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func configureUI() {
        title = "News"
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }

    func findImageChannel(id: String) -> Data {
        var channelData = Data()
        for channel in favoriteChannels where channel.channelId == id {
            channelData = channel.imageData ?? Data()
        }
        return channelData
    }
}

extension FavoriteNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return articles.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        230
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier) as? NewsCell
        else { return UITableViewCell() }

        let news = articles[indexPath.row]

        guard let titleNews = news.title,
              let descriprionNews = news.description,
              let imageUrlString = news.urlToImage,
              let nameChannel = news.source?.name,
              let channelId = news.source?.id
        else { return UITableViewCell() }

        cell.set(titleNews: titleNews,
                 descriptionNews: descriprionNews,
                 imageUrlString: imageUrlString,
                 nameChannel: nameChannel,
                 channelImage: findImageChannel(id: channelId))

        return cell
    }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let newsCount = articles.count
//print(numberChannel,favoriteChannels.count,indexPath.row,newsCount-1)
        if numberChannel < favoriteChannels.count && indexPath.row == newsCount-1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.getData1(times: 3)
            }
        }
    }

}
