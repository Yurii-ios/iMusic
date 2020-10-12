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
    func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchViewControllerBusinessLogic {
    var networkServices = NetworkService()
    
    var presenter: SearchViewControllerPresentationLogic?
    var service: SearchService?
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getTrack(let searchTerm):
            print("getTracks")
            presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
            
            // peredaem stroky s poiskom w func setewogo zaprosa
            networkServices.fetchTracks(searchText: searchTerm) { [weak self] (searchResponce) in
                // peredaem dannue dlia ich podgotowki
                self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponce: searchResponce))
            }
        }
    }
}
