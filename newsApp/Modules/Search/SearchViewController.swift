//
//  SearchViewController.swift
//  newsApp
//
//  Created by Нагоев Магомед on 19.04.2021.
//

import UIKit

class SearchViewController: UIViewController {

    private var articles = [News]()

    private var searchController = UISearchController()

    private var searchBar = UISearchBar()

    private let api = "8932dc51ea5f49c8b078c3063fffe07e"

    private var numberChannel = 0

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        hideKeyboardOnTap()
    }

    func configureUI() {
        title = "Search"
        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchBar
            searchBar.barStyle = .black
            searchBar.delegate = self
            searchBar.placeholder = "Search"
        }

        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)

        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier) as? NewsCell
        else { return UITableViewCell() }

        let news = articles[indexPath.row]

        guard let titleNews = news.title,
              let descriprionNews = news.description,
              let imageUrlString = news.urlToImage,
              let nameChannel = news.source?.name,
              let url = news.url
        else { return UITableViewCell() }

        guard let urlImage = URL(string: imageUrlString) else { return UITableViewCell()}

        cell.set(titleNews: titleNews,
                 descriptionNews: descriprionNews,
                 nameChannel: nameChannel,
                 channelImage: Data())

        cell.newsImage.kf.setImage(with: urlImage)

        cell.addImageUrl(url: url)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        230
    }

}

extension SearchViewController: UISearchBarDelegate {

    func getData (with searchText: String?) {
// print(searchText)
        if let text = searchText, text.count > 3 {
            let url = "https://newsapi.org/v2/everything?q=\(text)&apiKey=\(api)"

            NetworkManager.fetchData(url: url, model: Articles()) { [weak self](articles) in
                guard let news = articles.articles else { return }
                self?.articles = news

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.tableView.reloadData()
                }
            }
        } else {
            articles.removeAll()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView.reloadData()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getData(with: searchText)
    }
}

extension SearchViewController {

    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(SearchViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        if #available(iOS 11.0, *) {
            searchController.searchBar.endEditing(true)
        } else {
            searchBar.endEditing(true)
        }
    }
}
