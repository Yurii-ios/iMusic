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
        
        view.backgroundColor = .white
        
        // meniaem cvet  knopok tabBara
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
       
        // dobawliaem kontrolleru kotorue mu chotim videt w tab bare
        viewControllers = [generateViewController(rootViewController: SearchMusicViewController(), image: #imageLiteral(resourceName: "search"), title: "Search"), generateViewController(rootViewController: ViewController(), image: #imageLiteral(resourceName: "library"), title: "Library")]
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
}
