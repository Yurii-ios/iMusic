//
//  SearchViewController.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 24/09/2020.
//

import UIKit
import  Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            let url = "https://itunes.apple.com/search"
            let parametrs = ["term":"\(searchBar)","limit":"15"]
            Alamofire.request(url, method: HTTPMethod.get, parameters: parametrs, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
                if let error = dataResponse.error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = dataResponse.data else { return }
                // decodiryem dannue
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                    print(objects)
                    // zapolniaem masiw poly4ennumi dannumi
                    self.tracks = objects.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let error {
                    print("error:\(error.localizedDescription)")
                    
                }
                let someString = String(data: data, encoding: String.Encoding.utf8)
                
            }
            
        })
        }
}
    class SearchViewController: UITableViewController {
        
        private var timer: Timer?
        
        // chranit wse treki kotorue imeem
        private var tracks = [Track]()
        
        let searchController = UISearchController(searchResultsController: nil)
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
            
            setupSearchBar()
        }
        
        private func setupSearchBar() {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            searchController.searchBar.delegate = self
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // wozwr kol trekow
            return tracks.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
            let track = tracks[indexPath.row]
            cell.textLabel?.text = " \(track.trackName)\n\(track.artistName)"
            cell.textLabel?.numberOfLines = 2
            cell.imageView?.image = #imageLiteral(resourceName: "Image")
            return cell
        }
    }

