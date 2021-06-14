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
        return "\nResult - Kind: \(kind ?? "Nicht!"), Name: \(name), Artist Name: \(artistName ?? "Nicht!")"
    }
    
    var kind: String? = ""
    var artistName: String? = ""
    var trackName: String? = ""
    
    
    var trackPrice: Double? = 0.0
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    //added later
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    
    
    
    //Computed свойсва ,  мы делаем их из-за разного контента
    var name: String {
        return trackName ?? collectionName ?? ""
    }
    var storeUrl : String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    var price: Double {
        return trackPrice ?? itemPrice ?? collectionPrice ?? 0.0
    }
    var genre : String {
        if let genre = itemGenre {
            return genre
        } else if let genre = bookGenre {
            return genre.joined(separator: ", ")
        }
        return ""
    }
    
//    var type: String {
//        return kind ?? "audiobook"
//    } Мы поменяли , т.к нам не нравились приходящие свойства из Jsona
    var type: String {
        let kind = self.kind ?? "audiobook"
        switch kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "E-Book"
        case "feature-movie": return "Movie"
        case "music-video": return "Music Video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: break
        }
            
           return "Unknown"
    }
        var artist: String {
            return artistName ?? ""
        }
        enum CodingKeys : String, CodingKey{
            case imageSmall = "artworkUrl60"
            case imageLarge = "artworkUrl100"
            case itemGenre = "primaryGenreName"
            case bookGenre = "genres"
            case itemPrice = "price"
            
            case kind, artistName, trackName,trackViewUrl, collectionViewUrl
            case trackPrice, currency,collectionPrice
        }
    }
