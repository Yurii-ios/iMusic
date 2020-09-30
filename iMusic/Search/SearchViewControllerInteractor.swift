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
    var networkServices = NetworkService()
    
    var presenter: SearchViewControllerPresentationLogic?
    var service: SearchViewControllerService?
    
    func makeRequest(request: SearchViewController.Model.Request.RequestType) {
        if service == nil {
            service = SearchViewControllerService()
        }
        
        switch request {
        
        case .some:
            print("Some")
        case .getTrack(let searchTerm):
            print("getTracks")
            // peredaem stroky s poiskom w func setewogo zaprosa
            networkServices.fetchTracks(searchText: searchTerm) { [weak self] (searchResponce) in
                // peredaem dannue dlia ich podgotowki
                self?.presenter?.presentData(response: SearchViewController.Model.Response.ResponseType.presentTracks(searchResponce: searchResponce))
            }
        }
    }
}
