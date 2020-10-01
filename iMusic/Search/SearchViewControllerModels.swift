//
//  SearchViewControllerModels.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 27/09/2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//


//soderzanie pogo 4to vupolniaet iterator, presenter, viewController.
import UIKit

enum SearchViewController {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTrack(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(searchResponce: SearchResponse?)
        case presentFooterView
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(searchViewModel: SearchViewModel)
        case displayFooterView
      }
    }
  }
}

// sozdaem model dannuch kotoraja otnositsia k danomy modyly i ekrany, gde bydem chranit tolko to 4to nam nado

struct SearchViewModel {
    struct Cell: TrackCellWiewModel {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        var previewUrl: String?
    }
    
    let cells: [Cell]
}

