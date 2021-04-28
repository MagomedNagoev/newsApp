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
        if #available(iOS 13.0, *) {
        navigationController.tabBarItem.image = image
        }
        navigationController.navigationBar.barTintColor = .white
        navigationController.tabBarItem.title = tabBarItemTitle
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
        }
        return navigationController
    }

    func configureViewControllers() {
        var imageAllChannel = UIImage()
        var imageFavoriteChannel = UIImage()
        var imageSearch = UIImage()
        
        if #available(iOS 13.0, *) {
            imageAllChannel = UIImage(systemName: "newspaper")!
            imageFavoriteChannel = UIImage(systemName: "star")!
            imageSearch = UIImage(systemName: "magnifyingglass")!
        } else {
            var imageAllChannel1 = UIImageView()
            
            imageAllChannel1.image = UIImage(named: "channels")!
            imageAllChannel1.sizeThatFits(CGSize(width: 23, height: 23))
            imageAllChannel = imageAllChannel1.image!
        }
        let allChannelsViewController = AllChannelsViewController()

        let allChannelNavigationController = templateNavigationController(
            image: imageAllChannel,
            tabBarItemTitle: "All Channels",
            rootViewController: allChannelsViewController)

        
        let favoriteChannelsViewController = FavoriteChannelsViewController()
        let favoriteNavigationController = templateNavigationController(
            image: imageFavoriteChannel,
            tabBarItemTitle: "Favorite Channels",
            rootViewController: favoriteChannelsViewController)

        let searchViewController = SearchViewController()
        let searchNavigationController = templateNavigationController(
            image: imageSearch,
            tabBarItemTitle: "Search",
            rootViewController: searchViewController)
        if #available(iOS 13.0, *) {
        } else {
            let favoriteItem = UITabBarItem.SystemItem.favorites
            favoriteNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: favoriteItem, tag: 0)
            allChannelNavigationController.tabBarItem.image = imageAllChannel
            
            let searchItem = UITabBarItem.SystemItem.search
            searchNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: searchItem, tag: 0)
        }


        viewControllers = [allChannelNavigationController,
                           favoriteNavigationController,
                           searchNavigationController]
    }

}

extension UIImage {
    class func imageWithLabel(_ textLabel: String) -> UIImage {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 22))
        label.text = textLabel
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
