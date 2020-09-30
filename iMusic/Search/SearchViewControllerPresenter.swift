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
        switch response {
        
        case .some:
            print("some presenter")
        case .presentTracks(let searchResults):
            // sozdaem ja4ejki s informacuej
            let cells = searchResults?.results.map({ (track) in
                cellViewModel(from: track)
            }) ?? []
            let searchViewModel = SearchViewModel(cells: cells)
            print("presenter presenter")
            viewController?.displayData(viewModel: SearchViewController.Model.ViewModel.ViewModelData.displayTracks(searchViewModel: searchViewModel))
        }
    }


// konwertiruem obekt tipa Track w obekt tipa struct Cell
private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
    
    return SearchViewModel.Cell.init(iconUrlString:
                                        track.artworkUrl100!,
                                     trackName: track.trackName,
                                     collectionName: track.collectionName,
                                     artistName: track.artistName,
                                     previewUrl: track.previewUrl)
}
}
