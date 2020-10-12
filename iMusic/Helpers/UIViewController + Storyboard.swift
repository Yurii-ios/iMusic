//
//  UIViewController + Storyboard.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 27/09/2020.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        //poly4 imja controllera
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        // esli est viewController s imenem kak y storyBoard
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: No initial view controller in \(name) storyboard!")
        }
    }
}
