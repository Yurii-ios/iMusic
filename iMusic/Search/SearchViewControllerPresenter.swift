//
//  SearchViewControllerPresenter.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 27/09/2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

// poly4aet realnue dannue ot iteratora, a ot ViewControllera poly4aet spisok 4to emy nuzno predostavit w zavisimosti ot zaprosa.
import UIKit

protocol SearchViewControllerPresentationLogic {
  func presentData(response: SearchViewController.Model.Response.ResponseType)
}

class SearchViewControllerPresenter: SearchViewControllerPresentationLogic {
  weak var viewController: SearchViewControllerDisplayLogic?
  
  func presentData(response: SearchViewController.Model.Response.ResponseType) {
  
  }
  
}
