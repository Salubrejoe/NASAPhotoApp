//
//  NASAApiController.swift
//  NASAPhotoApi
//
//  Created by Lore P on 21/02/2023.
//

import UIKit


struct NASAAPIController {
    
    func fetchItems() async throws -> NasaPhotoInfo {
        
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "DEMO_KEY",
            "date"   : "2023-2-19"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        

        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200  else {
            throw NasaPhotoInfoError.failureToFetchData
        }
            
        let decoder     = JSONDecoder()
        let decodedData = try decoder.decode(NasaPhotoInfo.self, from: data)
        return decodedData
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200  else {
            throw NasaPhotoInfoError.failureToFetchData
        }
        
        guard let image = UIImage(data: data) else {
            throw NasaPhotoInfoError.failureToFetchImage
        }
        return image
    }
}
