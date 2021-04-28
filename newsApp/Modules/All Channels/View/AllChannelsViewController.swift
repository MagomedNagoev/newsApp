//
//  AllChannelsViewController.swift
//  newsApp
//
//  Created by Нагоев Магомед on 19.04.2021.
//

import UIKit
import PureLayout
import RealmSwift

class AllChannelsViewController: UIViewController, FavotiteChannelProtocol {

    private var favoriteChannels: Results<FavoriteChannel>!

    private let api = "8932dc51ea5f49c8b078c3063fffe07e"

    private var allChannels:ChannelSources?
    private var tableView:UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        favoriteChannels = realm?.objects(FavoriteChannel.self)
    }

//    override func viewWillAppear(_ animated: Bool) {
//        reloadTableview()
//        getData()
//    }

    func getData() {
        let url = "https://newsapi.org/v2/sources?apiKey=\(api)"
        NetworkManager.fetchData(url: url, model: allChannels) { [weak self](allChannels) in
            self?.allChannels = allChannels

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    func reloadTableview() {
        tableView.reloadData()
    }

    func configureUI() {
        title = "All Channel"
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewSafeArea()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.identifier)

    }

    func containsFavoriteCharacter(id: String) -> Bool {
        var isChannelFavorite: Bool = false
        for channel in favoriteChannels {
            if channel.channelId == id {
                isChannelFavorite = true
                break
            } else {
                isChannelFavorite = false
                continue
            }
        }
        return isChannelFavorite
    }
}

extension AllChannelsViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allChannels?.sources.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier) as?
                ChannelCell else { return UITableViewCell() }
        cell.delegate = self
        guard let allChannels = allChannels else { return UITableViewCell() }

        let channel = allChannels.sources[indexPath.row]
        let channelUrl = channel.url ?? ""
        cell.addImageUrl(url: channelUrl)
        let isFavoriteButton = containsFavoriteCharacter(id: channel.id!)
        cell.setData(name: channel.name ?? "",
                 description: channel.description ?? "",
                 numberChannel: indexPath.row,
                 numberOfLines: 0,
                 id: channel.id ?? "")

        cell.setFavoriteButton(isFavorite: isFavoriteButton)

        return cell
    }
}
