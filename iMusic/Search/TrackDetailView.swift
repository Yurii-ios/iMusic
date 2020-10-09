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
    @IBOutlet var miniTrackView: UIView!
    @IBOutlet var miniGoForwardButton: UIButton!
    @IBOutlet var maximizedStackView: UIStackView!
    @IBOutlet var miniTrackImageView: UIImageView!
    @IBOutlet var miniTrackTitleLabel: UILabel!
    @IBOutlet var miniPlayPauseButton: UIButton!
    
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
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    //MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let scale: CGFloat = 0.8
        // ymenshaem razmer zagryzenogo image
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        // raokrygliaem kraja image
        trackImageView.layer.cornerRadius = 5
        
        // ymenshaem knopky play-pause w mini view
        miniPlayPauseButton.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
        
        setupGestures()
    }
    
    //MARK: - Gestures 
    // realizowuwaem żestu
    private func setupGestures() {
        
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        // swaip w niz
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissPan)))
    }
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .possible:
            print("possible")
        case .began:
            print("began")
        case .changed:
            print("changed")
            handlePanChanged(gesture: gesture)
        case .ended:
            print("ended")
            handlePanEnded(gesture: gesture)
        case .cancelled:
            print("cancelled")
        case .failed:
            print("failed")
        @unknown default:
            print("default")
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        // logika dwigenija palcem
        let tranclation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: tranclation.y)
        
        let newAlpha = 1 + tranclation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -tranclation.y / 200
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        // 4ast ekrana
        let translation = gesture.translation(in: self.superview)
        // skorost
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            // 4tobu posle swaipa wwerch kogda is4ezaei miniView view kotoroe pojawliaetsia zapolnialo wes ekran
            self.transform = .identity
            //rastojanie na kotoroe podniat miniPlayer
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
            } else {
                self.miniTrackView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        } completion: { (_) in
            
        }

    }
    
    @objc private func handleDismissPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y )
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
                self.maximizedStackView.transform = .identity
                if translation.y > 50 {
                    self.tabBarDelegate?.minimizeTrackDetailController()
                }
            } completion: { (_) in
                
            }

        @unknown default:
            print("default")
        }
    }
    
    //MARK: - Setup
    
    //zagryzaem wse UI elementu
    func set(viewModel: SearchViewModel.Cell) {
        // nastraiwaem mini view, kotoraja pojawliaetsia posle swora4iwanija ekrana wniz
        miniTrackTitleLabel.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
        playPayseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        // izmeniaem razmer izobrazenija
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        
        // priwodim string k URL
        guard let url = URL(string: string600 ?? "") else { return }
        
        miniTrackImageView.sd_setImage(with: url, completed: nil)
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
        self.tabBarDelegate?.minimizeTrackDetailController()
        // udaliaem view
        //self.removeFromSuperview()
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
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPayseButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }
    }
}
