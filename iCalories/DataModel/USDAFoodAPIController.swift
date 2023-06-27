//
//  FoodAPIController.swift
//  iCalories
//
//  Created by Esad Dursun on 25.06.23.
//

import Foundation

struct FoodAPIController {
    
}

class USDAFoodAPIController {
    let baseURL = "https://api.nal.usda.gov/fdc/v1/"

    func searchFoodItems(withQuery query: String, completion: @escaping ([FoodItem]?, Error?) -> Void) {
        let urlString = "\(baseURL)foods/search?query=\(query)&api_key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }

            do {
                let decoder = JSONDecoder()
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                completion(searchResponse.foods, nil)
            } catch {
                completion(nil, error)
            }
        }

        task.resume()
    }
}

struct SearchResponse: Codable {
    let foods: [FoodItem]
    
    enum CodingKeys: String, CodingKey {
        case foods = "foods"
    }
}
