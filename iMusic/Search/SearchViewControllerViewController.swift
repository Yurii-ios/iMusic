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

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
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
  }
  
  func displayData(viewModel: SearchViewController.Model.ViewModel.ViewModelData) {

  }
  
}
