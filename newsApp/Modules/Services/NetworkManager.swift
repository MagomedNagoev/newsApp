//
//  NetworkManager.swift
//  newsApp
//
//  Created by Нагоев Магомед on 19.04.2021.
//

import Foundation
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

    static func fetchData<T: Decodable>(url: String, model: T, comletion:@escaping (_: T) -> Void) {
        guard let url = URL(string: url) else {
            print("Не удалось создать URL")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let charecters = try decoder.decode(T.self, from: data)

                comletion(charecters)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()

    }
}
