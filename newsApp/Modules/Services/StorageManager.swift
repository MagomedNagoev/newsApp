//
//  StorageManager.swift
//  newsApp
//
//  Created by Нагоев Магомед on 22.04.2021.
//

import RealmSwift

let realm = try? Realm()

class StorageManager {
    static func saveObject(name: String, descriptionChannel: String, image: UIImageView, channelId: String) {
        let favoriteChannel = FavoriteChannel()
        favoriteChannel.name = name
        favoriteChannel.descriptionChannel = descriptionChannel
        favoriteChannel.imageData = image.image?.pngData()
        favoriteChannel.channelId = channelId

        let channels = realm!.objects(FavoriteChannel.self)

        for channel in channels where channel.channelId == channelId {
            return
        }
        try? realm!.write {
            realm!.add(favoriteChannel)
        }
    }

    static func deleteObject(id: String) {
        let channels = realm!.objects(FavoriteChannel.self)
        for channel in channels where channel.channelId == id {
            try? realm!.write {
                realm!.delete(channel)
            }
        }
    }
}
