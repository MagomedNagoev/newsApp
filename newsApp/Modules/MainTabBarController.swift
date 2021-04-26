//
//  MainTabBarViewController.swift
//  newsApp
//
//  Created by Нагоев Магомед on 19.04.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
        configureViewControllers()
    }

    func configureTabbar() {
        tabBar.isTranslucent = false
    }

    func templateNavigationController(image: UIImage,
                                      tabBarItemTitle: String,
                                      rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.barTintColor = .white
        navigationController.tabBarItem.title = tabBarItemTitle
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }

    func configureViewControllers() {

        let allChannelsViewController = AllChannelsViewController()
        let allChannelNavigationController = templateNavigationController(
            image: UIImage(systemName: "newspaper")!,
            tabBarItemTitle: "All Channels",
            rootViewController: allChannelsViewController)

        let favoriteChannelsViewController = FavoriteChannelsViewController()
        let favoriteNavigationController = templateNavigationController(
            image: UIImage(systemName: "star")!,
            tabBarItemTitle: "Favorite Channels",
            rootViewController: favoriteChannelsViewController)

        let searchViewController = SearchViewController()
        let searchNavigationController = templateNavigationController(
            image: UIImage(systemName: "magnifyingglass")!,
            tabBarItemTitle: "Search",
            rootViewController: searchViewController)

        viewControllers = [allChannelNavigationController,
                           favoriteNavigationController,
                           searchNavigationController]
    }

}
