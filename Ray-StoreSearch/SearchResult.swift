//
//  SearchResult.swift
//  Ray-StoreSearch
//
//  Created by максим  кондратьев  on 14.06.2021.
//

import Foundation
import UIKit
//этот класс можно было положить и в отдельный файл , но чтобы все держать в одном , они решили оставить его тут

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
    
}

class SearchResult:Codable, CustomStringConvertible {
    var description: String {
        return "\nResult - Kind: \(kind ?? "Nicht!"), Name: \(name), Artist Name: \(artistName ?? "Nicht!"), Genre : \(genre)"
    }
    
    var kind: String? = ""
    var artistName: String? = ""
    var trackName: String? = ""
    
    var trackPrice: Double? = 0.0
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    var storeURL: String? = ""
    var genre = ""
    
    var name: String {
        return trackName ?? ""
    }
    
    enum CodingKeys : String, CodingKey{
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case storeURL = "trackViewUrl"
        case genre = "primaryGenreName"
        case kind, artistName, trackName
        case trackPrice, currency
    }
}
