//
//  SearchViewControllerInteractor.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 27/09/2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

// peredaet swoi dannue presentery
import UIKit

protocol SearchViewControllerBusinessLogic {
  func makeRequest(request: SearchViewController.Model.Request.RequestType)
}

class SearchViewControllerInteractor: SearchViewControllerBusinessLogic {

  var presenter: SearchViewControllerPresentationLogic?
  var service: SearchViewControllerService?
  
  func makeRequest(request: SearchViewController.Model.Request.RequestType) {
    if service == nil {
      service = SearchViewControllerService()
    }
  }
  
}
