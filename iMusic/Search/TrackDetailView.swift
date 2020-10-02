//
//  TrackDetailView.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 01/10/2020.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailView: UIView {
    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var currentTimeSlider: UISlider!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var trackTitleLabel: UILabel!
    @IBOutlet var authorTitleLabel: UILabel!
    @IBOutlet var playPayseButton: UIButton!
    @IBOutlet var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        //snizaem zaderzky wuzowa avPlayer pri ego wuzowe
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //zagryzaem wse UI elementu
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        
        // izmeniaem razmer izobrazenija
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        
        // priwodim string k URL
        guard let url = URL(string: string600 ?? "") else { return }
        // zagryzaem image
        trackImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
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
        if player.timeControlStatus == .paused {
            player.play()
            playPayseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        } else {
            player.pause()
            playPayseButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
        }
    }
}
