//
//  NASAPhotoInfo.swift
//  NASAPhotoApi
//
//  Created by Lore P on 21/02/2023.
//

import Foundation

struct NasaPhotoInfo: Codable {
    var title       : String
    var description : String
    var url         : URL
    var copyright   : String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url         = "hdurl"
        case copyright
    }
}

enum NasaPhotoInfoError: Error {
    case failureToFetchData
    case failureToFetchImage
}
