//
//  FoodAPIController.swift
//  iCalories
//
//  Created by Esad Dursun on 25.06.23.
//

import Foundation

struct FoodAPIController {
    let baseURL = "https://api.calorieninjas.com/v1/"
    
    func searchFoodItems(withQuery query: String, completion: @escaping ([FoodItem]?, Error?) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)nutrition?query=\(encodedQuery)"

        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }
            
            print(String(data: data, encoding: .utf8))

            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                completion(searchResponse.items, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }
}

struct SearchResponse: Codable {
    let items: [FoodItem]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}

