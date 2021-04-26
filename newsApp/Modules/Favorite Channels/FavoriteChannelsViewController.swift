//
//  FavoriteChannelsViewController.swift
//  newsApp
//
//  Created by Нагоев Магомед on 19.04.2021.
//

import UIKit
import RealmSwift
import PureLayout

protocol FavotiteChannelProtocol: class {
    func reloadTableview()
}

class FavoriteChannelsViewController: UIViewController, FavotiteChannelProtocol {
    private var favoriteChannels: Results<FavoriteChannel>!

    private var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteChannels = realm?.objects(FavoriteChannel.self)
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadTableview()
    }

    func reloadTableview() {
        tableView.reloadData()
    }

    func configureUI() {
        title = "Favorite Channels"

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show News",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(showNews))

        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewSafeArea()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.identifier)

    }

    @objc func showNews() {
        let favoriteNewsViewController = FavoriteNewsViewController()
        navigationController?.pushViewController(favoriteNewsViewController, animated: true)
    }
}

extension FavoriteChannelsViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteChannels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.identifier) as?
                ChannelCell else { return UITableViewCell() }

        let channel = favoriteChannels[indexPath.row]

        cell.setData(name: channel.name ?? "",
                 description: channel.descriptionChannel ?? "",
                 numberChannel: indexPath.row,
                 numberOfLines: 2,
                 id: channel.channelId ?? "")

        cell.setFavoriteButton(isFavorite: true)

        cell.addImageDB(imageData: channel.imageData)

        cell.delegate = self

        return cell
    }

}
