//
//  Channel.swift
//  newsApp
//
//  Created by Нагоев Магомед on 19.04.2021.
//

import Foundation
import RealmSwift

struct Channel: Decodable {
    let id:String?
    let name:String?
    let description:String?
    let url:String?
    let category:String?
    let language:String?
    let country:String?
}

struct ChannelSources: Decodable {
    var sources:[Channel]
}

class FavoriteChannel: Object {

    @objc dynamic var name: String?
    @objc dynamic var descriptionChannel: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var channelId: String?

    convenience init (name: String?,descriptionChannel: String? ,imageData: Data?, channelId: String?) {
        self.init()
        self.name = name
        self.imageData = imageData
        self.channelId = channelId
        self.descriptionChannel = descriptionChannel
    }
}
