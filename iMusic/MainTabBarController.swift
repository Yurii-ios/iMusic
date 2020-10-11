//
//  MainTabBarController.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 24/09/2020.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    private var searchVC: SearchViewControllerViewController!
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTrackDetailView()
        
        searchVC?.tabBardelegate = self
        
        var library = Library()
        library.tabBarDelegate = self
        // pomes4aem SwiftUIView w chosting controller
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "library")
        hostVC.tabBarItem.title = "Library"
        
        // meniaem cvet  knopok tabBara
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        // podgryzaem viewController is storyborda a ne iz failow swift
        searchVC = SearchViewControllerViewController.loadFromStoryboard()
        
        // dobawliaem kontrolleru kotorue mu chotim videt w tab bare
        
        guard let search = searchVC else { return }
        viewControllers =  [ hostVC, generateViewController(rootViewController: search, image: #imageLiteral(resourceName: "search"), title: "Search")]
    }
    
    private func generateViewController (rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        // ystanawliwaem izobraz dlia knopki tabBara
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        // delaem bar bolshum
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    // nastraiwaem TrackDetailView
    private func setupTrackDetailView() {
        print("setupTrackDetailView")
        
        trackDetailView.backgroundColor = .white
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        // view.addSubview(trackDetailView)
        // tabbar powerch view
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        // use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        maximizedTopAnchorConstraint.isActive = true
        //trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            // obnowliaem view kazdyjy milisec 4tobu ywidet animacujy pri swora4iwanii view do minim sostojanija
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.maximizedStackView.alpha = 1
        } completion: { (_) in
            
        }
        
        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
        
        // peredwigaem tabBar na zadanue koordnatu
        self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
    }
    
    func minimizeTrackDetailController() {
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            // obnowliaem view kazdyjy milisec 4tobu ywidet animacujy pri swora4iwanii view do minim sostojanija
            self.view.layoutIfNeeded()
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.maximizedStackView.alpha = 0
            self.tabBar.alpha = 1
        } completion: { (_) in
            
        }
    }
}

