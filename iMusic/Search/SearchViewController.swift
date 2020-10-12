//
//  SearchViewControllerViewController.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 27/09/2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

// otwe4aet za otobrazenie dannuch na ekran, beret dannue y iteratora
import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

  var interactor: SearchViewControllerBusinessLogic?
  var router: (NSObjectProtocol & SearchViewControllerRoutingLogic)?

    @IBOutlet var table: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel(cells: [])
    private var timer: Timer?
    
    private lazy var footerView = FooterView()
    var tabBardelegate: MainTabBarControllerDelegate?
    
    
  // MARK: Setup
  
    private func setup() {
      let viewController        = self
      let interactor            = SearchInteractor()
      let presenter             = SearchPresenter()
      let router                = SearchRouter()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let keyWindow = UIApplication.shared.connectedScenes.filter({
            $0.activationState == .foregroundActive
        }).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
        let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
        tabBarVC?.trackDetailView.delegate = self
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
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        self.tabBardelegate?.maximizeTrackDetailController(viewModel: cellViewModel)
        print(tabBardelegate?.maximizeTrackDetailController(viewModel: cellViewModel))
        
        print(cellViewModel.trackName)
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self]
            (_) in
            self?.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTrack(searchTerm: searchText))
        })
    }
}

extension SearchViewController: TrackMovingDelegate {
    
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == searchViewModel.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = searchViewModel.cells.count - 1
            }
        }
        
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel = searchViewModel.cells[nextIndexPath.row]
        return cellViewModel
    }
    
    func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwardTrack: false)
        
    }
    
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwardTrack: true)
    }
}
