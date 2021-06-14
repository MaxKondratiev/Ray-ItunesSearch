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

class SearchResult:Codable {
    var artistName: String? = ""
    var trackName: String? = ""
    
    var name: String {
        return trackName ?? ""
    }
}
