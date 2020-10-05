//
//  TrackDetailView.swift
//  iMusic
//
//  Created by Yurii Sameliuk on 01/10/2020.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: class {
    func moveBackForPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardForPreviousTrack() -> SearchViewModel.Cell?
}

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
    
    weak var delegate: TrackMovingDelegate?
    
    //MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale: CGFloat = 0.8
        // ymenshaem razmer zagryzenogo image
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        // raokrygliaem kraja image
        trackImageView.layer.cornerRadius = 5
    }
    
    //MARK: - Setup
    
    //zagryzaem wse UI elementu
    func set(viewModel: SearchViewModel.Cell) {
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
        
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
    
    //MARK: - Time Setup
    
    private func monitorStartTime() {
        // stryktyra kotoraja pozwoliaet otslezuwat wremia
        let time = CMTimeMake(value: 1, timescale: 3)
        // pomes4aem time w masiw
        let times = [NSValue(time: time)]
        // otslezuwaem moment proigruwanija treka dlia izmenenija razmera image
        player.addBoundaryTimeObserver(forTimes: times, queue: DispatchQueue.main) { [weak self] in
            // 4to wupolnitsia kogda danuj moment bydet otslezen
            self?.enlargeTrackImageView()
        }
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            // obs4ee wremia kompozicui
            let durationTime = self?.player.currentItem?.duration
            // ostawcheesia wremia
            let currentDuration = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDuration)"
            self?.updateCurrentTemeSlider()
        }
    }
    
    private func updateCurrentTemeSlider() {
        // tekys4ee zna4enie payer
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        // prodolzitelnost treka
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        // cootnoshenie
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    //MARK: - Animation
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            //yweli4iwaem razmer image
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            let scale: CGFloat = 0.8
            // ymenshaem razmer zagryzenogo image
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    //MARK: - @IBActions8
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInseconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInseconds, preferredTimescale: 1)
        player.seek(to: seekTime)
        
    }
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        // udaliaem view
        self.removeFromSuperview()
    }
    @IBAction func previousTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveBackForPreviousTrack()
        guard let cell = cellViewModel else { return }
        self.set(viewModel: cell)
    }
    @IBAction func nextTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveForwardForPreviousTrack()
        guard let cell = cellViewModel else { return }
        self.set(viewModel: cell) 
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPayseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPayseButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
            reduceTrackImageView()
        }
    }
}
