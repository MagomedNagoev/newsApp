//
//  News.swift
//  newsApp
//
//  Created by Нагоев Магомед on 24.04.2021.
//

import Foundation
struct News: Decodable {
    var source: Source?
    let author :String?
    let title :String?
    let description :String?
    let url :String?
    let urlToImage :String?
    let content :String?
}

struct Source:Decodable {
    let id: String?
    let name: String?
}

struct Articles:Decodable {
    var articles:[News]?
}
