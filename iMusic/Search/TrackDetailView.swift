//
//  TrackDetailView.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 01/10/2020.
//

import UIKit
import SDWebImage

class TrackDetailView: UIView {
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var currentTimeSlider: UISlider!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var trackTitleLabel: UILabel!
    @IBOutlet var authorTitleLabel: UILabel!
    @IBOutlet var playPayseButton: UIButton!
    @IBOutlet var volumeSlider: UISlider!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //zagryzaem wse UI elementu
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        // izmeniaem razmer izobrazenija
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        
        // priwodim string k URL
        guard let url = URL(string: string600 ?? "") else { return }
        
        // zagryzaem image
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        
    }
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    @IBAction func dragDownButtonTapped(_ sender: Any) {
      // udaliaem view
        self.removeFromSuperview()
    }
    @IBAction func previousTrack(_ sender: Any) {
    }
    @IBAction func nextTrack(_ sender: Any) {
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
    }
}
