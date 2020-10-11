//
//  TrackCell.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 30/09/2020.
//

import UIKit
import SDWebImage

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
    
    @IBOutlet var addTrackOutlet: UIButton!
    
    // danuj metod wuzuwaetsia tolko w tom sly4ae kogda cell skonfigyirowan 4erez xib
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // ydaliaet ja4ejki s pamiati kogda oni wuchodiat za predelu oblasti widimosti
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackImageView.image = nil
    }
    
    var cell: SearchViewModel.Cell?
    
    // srabatuwaet kogda mu podgryzaem nowyjy ja4ejky
    func set(viewModel: SearchViewModel.Cell) {
        
        self.cell = viewModel
        // proweriaem dobawlen li treck w userDefaults
        let savedTracks = UserDefaults.standard.savedTracks()
        // proweriaem sowpadajyt li dannue w savedTracks masiwe s dannumi w viewModel
        let hasFavourite = savedTracks.firstIndex {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        } != nil
        // esli est w masiwe - pria4em knopky addTrackAction
        if hasFavourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        //podgryzaem informacuju s interneta i kechuryem ee
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    @IBAction func addTrackAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        // soderzut masiw so spiskom trekov
        guard let cell = cell else { return }
        addTrackOutlet.isHidden = true
        
        var listOfTracks = defaults.savedTracks()
        listOfTracks.append(cell)
        
        // sochraniaem dannue kotorue chraniatsia w cell
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks , requiringSecureCoding: false) {
            defaults.setValue(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}
