//
//  MainTabBarController.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 24/09/2020.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        let searchVC = SearchViewController()
        let libraryVC = ViewController()
        
        //
        let navigationVC = UINavigationController(rootViewController: searchVC)
        
        // dobawliaem kontrolleru kotorue mu chotim videt w tab bare
        viewControllers = [navigationVC, libraryVC]
    }
}
