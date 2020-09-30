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
        case some
        case getTrack(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
        case presentTracks(searchResponce: SearchResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
        case displayTracks(searchViewModel: SearchViewModel)
      }
    }
  }
}

// sozdaem model dannuch kotoraja otnositsia k danomy modyly i ekrany, gde bydem chranit tolko to 4to nam nado

struct SearchViewModel {
    struct Cell {
        var iconUrlString: String
        var trackName: String
        var collectionName: String
        var artistName: String
    }
    
    let cells: [Cell]
}

