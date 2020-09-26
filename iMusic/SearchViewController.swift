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
       // print(searchText)
       
        let url = "https://itunes.apple.com/search?term=\(searchText)"
        Alamofire.request(url).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = dataResponse.data else { return }
            
            let someString = String(data: data, encoding: String.Encoding.utf8)
            print("This is my string: \(someString ?? "Empty string")")
        }
    
    }
}

class SearchViewController: UITableViewController {
    
    // chranit wse treki kotorue imeem
    let tracks = [TrackModel(trackName: "xxx", artistName: "XXX"), TrackModel(trackName: "eeee", artistName: "EEEE")]
    
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

