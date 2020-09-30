//
//  TrackCell.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 30/09/2020.
//

import UIKit
// ograzdaem klass TreckCell ot izlishnej informacii po ja4ejke
protocol TrackCellWiewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
    
}

class TrackCell: UITableViewCell {
    
    // identificator
    static let reuseId = "TrackCell"
   
    @IBOutlet var trackNameLabel: UILabel!
    @IBOutlet var artistNameLabel: UILabel!
    @IBOutlet var collectionNameLabel: UILabel!
    
    @IBOutlet var trackImageView: UIImageView!
    
    // danuj metod wuzuwaetsia tolko w tom sly4ae kogda cell skonfigyirowan 4erez xib
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: TrackCellWiewModel) {
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
    }
}
