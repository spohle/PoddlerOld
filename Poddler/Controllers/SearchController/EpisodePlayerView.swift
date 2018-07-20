//
//  EpisodePlayerView.swift
//  Poddler
//
//  Created by Sven Pohle on 7/18/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import MediaPlayer

class EpisodePlayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(r: 40, g: 40, b: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var episode:Episode?
    var podcastImageUrl: String?
    var playing = false
    
    var mediaPlayer: AVPlayer?
    var playerItem: AVPlayerItem?
    var totalSeconds:Int?
    var observerToken:Any?
    
    lazy var uiDismissButton:UIButton = {
       let button = UIButton()
        
        button.setTitle("DISMISS", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let uiImageView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let uiTimeSlider:UISlider = {
        let slider = UISlider()
        
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let uiTimePlayedLabel:UILabel = {
       let label = UILabel()
        
        label.text = "00:00:00"
        label.textAlignment = .left
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uiTimeLeftLabel:UILabel = {
        let label = UILabel()
        
        label.text = "00:00:00"
        label.textAlignment = .right
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uiTitleLabel: UILabel = {
       let label = UILabel()
        
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uiAuthorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(r: 242, g: 109, b: 124)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uiSkipBackButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "skipBack")?.imageScaled(to: CGSize(width: 50, height: 50)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.lightGray
        
        button.addTarget(self, action: #selector(handleSkipForward), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let uiPlayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play")?.imageScaled(to: CGSize(width: 50, height: 50)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.lightGray
        
        button.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let uiSkipForwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "skipForward")?.imageScaled(to: CGSize(width: 50, height: 50)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.lightGray
        
        button.addTarget(self, action: #selector(handleSkipBackward), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let uiMainStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let uiPlayTimeLabelsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let uiPlayButtonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let uiVolumeSlider: UISlider = {
        let slider = UISlider()
        
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0
        
        slider.value = AVAudioSession.sharedInstance().outputVolume * 100.0
        
        slider.minimumValueImage = UIImage(named: "low-volume")?.tinted(with: UIColor.lightGray)
        slider.maximumValueImage = UIImage(named: "hi-volume")?.tinted(with: UIColor.lightGray)
        
        slider.addTarget(self, action: #selector(handleVolumeChange), for: .valueChanged)
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let uiEmptyView: UIView = {
       let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupUserInterface() {
        addSubview(uiMainStackView)
        uiMainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        uiMainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        uiMainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uiMainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        uiDismissButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        var urlString = episode?.imageUrl ?? ""
        if !urlString.contains("https") {
            urlString = urlString.replacingOccurrences(of: "http", with: "https")
        }
        
        if urlString == "" {
            urlString = podcastImageUrl ?? ""
        }
        
        let imageUrl = URL(string: urlString)

        uiImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "appicon"))
        uiImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        uiImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        uiTimeSlider.widthAnchor.constraint(equalToConstant: frame.width*0.8).isActive = true
        uiTimeSlider.heightAnchor.constraint(equalToConstant: uiTimeSlider.frame.height).isActive = true
        
        uiPlayTimeLabelsStackView.widthAnchor.constraint(equalToConstant: frame.width*0.8).isActive = true
        uiPlayTimeLabelsStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        uiTimePlayedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        uiTimeLeftLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        uiPlayTimeLabelsStackView.addArrangedSubview(uiTimePlayedLabel)
        uiPlayTimeLabelsStackView.addArrangedSubview(uiTimeLeftLabel)
        
        uiTitleLabel.widthAnchor.constraint(equalToConstant: frame.width*0.8).isActive = true
        uiTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        uiTitleLabel.text = episode?.title
        
        uiAuthorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        uiAuthorLabel.text = episode?.author
        
        uiSkipBackButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        uiPlayButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        uiSkipForwardButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let emptyView = UIView()
        emptyView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        let emptyView2 = UIView()
        emptyView2.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        uiPlayButtonsStackView.addArrangedSubview(uiSkipBackButton)
        uiPlayButtonsStackView.addArrangedSubview(emptyView)
        uiPlayButtonsStackView.addArrangedSubview(uiPlayButton)
        uiPlayButtonsStackView.addArrangedSubview(emptyView2)
        uiPlayButtonsStackView.addArrangedSubview(uiSkipForwardButton)
        
        uiVolumeSlider.widthAnchor.constraint(equalToConstant: frame.width*0.8).isActive = true
        
        uiMainStackView.addArrangedSubview(uiDismissButton)
        uiMainStackView.addArrangedSubview(uiImageView)
        uiMainStackView.addArrangedSubview(uiTimeSlider)
        uiMainStackView.addArrangedSubview(uiPlayTimeLabelsStackView)
        uiMainStackView.addArrangedSubview(uiTitleLabel)
        uiMainStackView.addArrangedSubview(uiAuthorLabel)
        uiMainStackView.addArrangedSubview(uiPlayButtonsStackView)
        uiMainStackView.addArrangedSubview(uiVolumeSlider)
        uiMainStackView.addArrangedSubview(uiEmptyView)
        
        // set some custom spacing
        uiMainStackView.setCustomSpacing(20.0, after: uiImageView)
        uiMainStackView.setCustomSpacing(15.0, after: uiAuthorLabel)
        uiMainStackView.setCustomSpacing(40, after: uiPlayButtonsStackView)
    }
    
    @objc func handleDismiss() {
        self.mediaPlayer?.pause()
        self.mediaPlayer?.removeTimeObserver(self.observerToken!)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.frame.origin.y += self.frame.size.height
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    @objc func handlePlayPause() {
        if self.playing == true {
            let image = UIImage(named: "play")?.imageScaled(to: CGSize(width: 50, height: 50)).withRenderingMode(.alwaysTemplate)
            uiPlayButton.setImage(image, for: .normal)
            self.playing = false
            self.mediaPlayer?.pause()
        } else {
            let image = UIImage(named: "pause")?.imageScaled(to: CGSize(width: 50, height: 50)).withRenderingMode(.alwaysTemplate)
            uiPlayButton.setImage(image, for: .normal)
            self.playing = true
            self.mediaPlayer?.play()
        }
    }
    
    @objc func handleSkipForward() {
        guard let currentTime = self.mediaPlayer?.currentTime() else { return }
        
        let offsetTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(currentTime) - 15, preferredTimescale: currentTime.timescale);
        
        guard let player = self.mediaPlayer else { return }
        player.seek(to: offsetTime)
        self.updateUserInterface()
    }
    
    @objc func handleSkipBackward() {
        guard let currentTime = self.mediaPlayer?.currentTime() else { return }
        
        let offsetTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(currentTime) + 15, preferredTimescale: currentTime.timescale);
        
        guard let player = self.mediaPlayer else { return }
        player.seek(to: offsetTime)
        self.updateUserInterface()
    }
    
    @objc func handleSliderChange() {
        let value = self.uiTimeSlider.value
        let offsetSeconds = Double(value/100.0) * Double(self.totalSeconds!)
        guard let currentTime = self.mediaPlayer?.currentTime() else { return }
        let playTime = CMTime(seconds: offsetSeconds, preferredTimescale: currentTime.timescale)
        guard let player = self.mediaPlayer else { return }
        player.seek(to: playTime)
    }
    
    @objc func handleVolumeChange() {
        self.mediaPlayer?.volume = self.uiVolumeSlider.value / 100.0
    }
}

extension EpisodePlayerView {
    func prepareToPlay() {
        let url = URL(string: episode?.streamUrl ?? "")
        
        // Create asset to be played
        let asset = AVAsset(url: url!)
        
        let assetKeys = [
            "playable",
            "hasProtectedContent"
        ]
        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        self.playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
        
        
        // Register as an observer of the player item's status property
        self.playerItem?.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: nil)
        
        // Associate the player item with the player
        mediaPlayer = AVPlayer(playerItem: playerItem)
    }
    
    func playAudio() {
        let image = UIImage(named: "pause")?.imageScaled(to: CGSize(width: 50, height: 50)).withRenderingMode(.alwaysTemplate)
        uiPlayButton.setImage(image, for: .normal)
        
        if let player = mediaPlayer {
            self.playing = true
            self.totalSeconds = self.mediaPlayer?.currentItem?.asset.duration.seconds.toInt()!
            player.play()
            addPeriodicTimeObserver()
        } else {
            return
        }
    }
    
    func addPeriodicTimeObserver() {
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        // Add time observer
        let timeObserverToken = self.mediaPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) {
                [weak self] time in
            self?.updateUserInterface()
        }
        
        self.observerToken = timeObserverToken
    }
    
    func updateUserInterface() {
        let currentSeconds = self.mediaPlayer?.currentTime().seconds.toInt()
        let remainingSeconds = (self.totalSeconds ?? 0) - (currentSeconds ?? 0)
        
        let (phours, pminutes, pseconds) = self.secondsToHoursMinutesSeconds(seconds: currentSeconds ?? 0)
        self.uiTimePlayedLabel.text = String(format: "%02d:%02d:%02d", phours, pminutes, pseconds)
        
        let (rhours, rminutes, rseconds) = self.secondsToHoursMinutesSeconds(seconds: remainingSeconds)
        self.uiTimeLeftLabel.text = String(format: "%02d:%02d:%02d", rhours, rminutes, rseconds)
        
        let percentagePlayed = 100.0 - (Double(remainingSeconds) / (Double(self.totalSeconds ?? 0) / 100.0))
        self.uiTimeSlider.value = Float(percentagePlayed)
    }
    
   
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == context else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
                print("ready to play")
                playAudio()
            case .failed:
                print("failed")
            case .unknown:
                print("unknown error")
            }
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

extension Double {
    func toInt() -> Int? {
        if self > Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
