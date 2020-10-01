//
//  FooterView.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 01/10/2020.
//

import UIKit

class FooterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
    
    // sozdaem label s nastrojkami po ymol4anijy
    private var myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        // false - esli nam nyzno nastroi constraintu s pomos4jy koda
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        return label
    }()
    
    //sozdaem activityIndicator s nastrojkami po ymol4anijy
    private var loader: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    // dobawliaem labei i activityIndicator na FooterView
    private func setupElements() {
        addSubview(myLabel)
        addSubview(loader)
        // ystanawliwaem werchnyjy granicy
        loader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        //ystanawliwaem lewyjy granicy
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        // ystanawliwaem prawyjy granicy
        loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        // razmes4aem po centry
        myLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        // razmes4aem po gorizontali
        myLabel.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
    }
    
    func showLoader() {
        loader.startAnimating()
        myLabel.text = "LOADING"
    }
    
    func hideLoader() {
        loader.stopAnimating()
        myLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
