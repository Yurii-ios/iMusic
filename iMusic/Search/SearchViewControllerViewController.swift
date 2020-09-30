//
//  SearchViewControllerViewController.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 27/09/2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

// otwe4aet za otobrazenie dannuch na ekran, beret dannue y iteratora
import UIKit

protocol SearchViewControllerDisplayLogic: class {
  func displayData(viewModel: SearchViewController.Model.ViewModel.ViewModelData)
}

class SearchViewControllerViewController: UIViewController, SearchViewControllerDisplayLogic {

  var interactor: SearchViewControllerBusinessLogic?
  var router: (NSObjectProtocol & SearchViewControllerRoutingLogic)?

    @IBOutlet var table: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel(cells: [])
    private var timer: Timer?
    
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchViewControllerInteractor()
    let presenter             = SearchViewControllerPresenter()
    let router                = SearchViewControllerRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupSearchBar()
    setupTableView()
  }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        // pozwoliaet ne zatemniatsia ekranu kogda mu wwodim 4toto w bare
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    // registriruem ja4ejky
    private func setupTableView() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
  
  func displayData(viewModel: SearchViewController.Model.ViewModel.ViewModelData) {
    switch viewModel {
   
    case .some:
        print("view some")
    case .displayTracks(let searchViewModel):
        self.searchViewModel = searchViewModel
        table.reloadData()
        print("view displayTracks")
    }
  }
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewControllerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        cell.textLabel?.text = cellViewModel.trackName + "\n" + cellViewModel.artistName
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.image = #imageLiteral(resourceName: "Image")
        return cell
    }
    
    
}

extension SearchViewControllerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self]
            (_) in
            self?.interactor?.makeRequest(request: SearchViewController.Model.Request.RequestType.getTrack(searchTerm: searchText))
        })
    }
}
