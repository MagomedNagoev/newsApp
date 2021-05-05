//
//  NetworkManager.swift
//  newsApp
//
//  Created by Нагоев Магомед on 19.04.2021.
//

import Foundation
import Alamofire

class NetworkManager {

    static func getRequest(url: String) {

        guard let url = URL(string: url) else {
            print("Не удалось создать URL")
            return
        }

        let session = URLSession.shared

        session.dataTask(with: url) {(data, response, error) in
            guard let response = response, let data = data else {
                return
            }
            print("response: \(response)")
            print("data: \(data)")

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("json:\(json)")
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

    static func fetchData<T: Decodable>(url: String, model: T, comletion:@escaping (T) -> Void) {
        guard let url = URL(string: url) else {
            print("Не удалось создать URL")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let models = try decoder.decode(T.self, from: data)

                comletion(models)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()

    }

    static func fetchDataCache(url: String, comletion:@escaping (Articles) -> Void) {

        guard let url = URL(string: url) else {
            print("Не удалось создать URL")
            return }

        let request = URLRequest(url: url,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 20)

        AF.request(request).responseJSON { (response) in
            guard let newResponse = response.response,
                  let data = response.data,
                  let request = response.request else {
                return
            }

            let cachedURLResponse = CachedURLResponse(response: newResponse,
                                                      data: data,
                                                      userInfo: nil,
                                                      storagePolicy: .allowed)

            URLCache.shared.storeCachedResponse(cachedURLResponse, for: request)

            guard response.error == nil else {
                print("error")
                print(response.error!)
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let articles = try decoder.decode(Articles.self, from: cachedURLResponse.data)

                comletion(articles)

            } catch let error {
                print(error.localizedDescription)
            }
        }

    }
}
