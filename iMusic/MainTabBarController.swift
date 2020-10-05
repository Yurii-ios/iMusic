//
//  MainTabBarController.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 24/09/2020.
//

import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
}

class MainTabBarController: UITabBarController {
    
    private var searchVC: SearchViewControllerViewController!
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTrackDetailView()
        
        // meniaem cvet  knopok tabBara
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        // podgryzaem viewController is storyborda a ne iz failow swift
        searchVC = SearchViewControllerViewController.loadFromStoryboard()
        
        // dobawliaem kontrolleru kotorue mu chotim videt w tab bare
        viewControllers = [generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "search"), title: "Search"), generateViewController(rootViewController: ViewController(), image: #imageLiteral(resourceName: "library"), title: "Library")]
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
        
        let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
        trackDetailView.backgroundColor = .yellow
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        // view.addSubview(trackDetailView)
        // tabbar powerch view
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        // use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
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
    func minimizeTrackDetailController() {
        
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            // obnowliaem view kazdyjy milisec 4tobu ywidet animacujy pri swora4iwanii view do minim sostojanija
            self.view.layoutIfNeeded()
        } completion: { (_) in
            
        }
        
    }
    
    
}
