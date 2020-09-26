//
//  SearchResponse.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 26/09/2020.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String
    var artistName: String
    var artworkUrl100: String?
}
