//
//  NetworkService.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 27/09/2020.
//

import UIKit
import Alamofire

class NetworkService {
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parametrs = ["term":"\(searchText)","limit":"100","media": "music"]
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = dataResponse.data else { return }
            // decodiryem dannue
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                print(objects)
                completion(objects)
    
            } catch let error {
                print("error:\(error.localizedDescription)")
                completion(nil)
            }
            //let someString = String(data: data, encoding: String.Encoding.utf8)
            
        }
    }
}
