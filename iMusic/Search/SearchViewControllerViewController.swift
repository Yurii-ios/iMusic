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
    
    private lazy var footerView = FooterView()
    
    
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
    
    //zagryzka rezyltatow po ymol4aniju
    searchBar(searchController.searchBar, textDidChange: "Sond")
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
        
        // yberaem na pystom ekrane poloski
        table.tableFooterView = footerView
        
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        // registriruem cell xib
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
    }
  
  func displayData(viewModel: SearchViewController.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayTracks(let searchViewModel):
        self.searchViewModel = searchViewModel
        table.reloadData()
        footerView.hideLoader()
        print("view displayTracks")
    case .displayFooterView:
        footerView.showLoader()
    }
  }
  
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewControllerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        print(cellViewModel.previewUrl!)
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModel)
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = searchViewModel.cells[indexPath.row ]
        
        // tekys4ee okno
        let window = UIApplication.shared.keyWindow
        
        let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as! TrackDetailView
        
        trackDetailsView.set(viewModel: cellViewModel)
        window?.addSubview(trackDetailsView)
    }
    
    // ystanawlivaem konstantnyju weli4iny dlia ja4ejki
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter search ..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    // metod otwe4aet za wusoty header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // skruwaem label kogda pojawliajutsia rezyltatu poiska
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
}

//MARK: - UISearchBarDelegane

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
