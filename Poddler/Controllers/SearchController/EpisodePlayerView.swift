//
//  EpisodePlayerView.swift
//  Poddler
//
//  Created by Sven Pohle on 7/18/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import SDWebImage

class EpisodePlayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(r: 240, g: 240, b: 240)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var episode:Episode?
    
    lazy var uiDismissButton:UIButton = {
       let button = UIButton()
        
        button.setTitle("DISMISS", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let uiImageView:UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 20, height: 20)
//        view.layer.shadowRadius = 10
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let uiTimeSlider:UISlider = {
        let slider = UISlider()
        
        slider.minimumValue = 0.0
        slider.maximumValue = 100.0
       
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let uiTimePlayedLabel:UILabel = {
       let label = UILabel()
        
        label.text = "00:00"
        label.textAlignment = .left
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uiTimeLeftLabel:UILabel = {
        let label = UILabel()
        
        label.text = "00:00"
        label.textAlignment = .right
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uiTitleLabel: UILabel = {
       let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let uiSkipBackButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "skipBack")?.imageScaled(to: CGSize(width: 50, height: 50)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let uiPlayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play")?.imageScaled(to: CGSize(width: 50, height: 50)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let uiSkipForwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "skipForward")?.imageScaled(to: CGSize(width: 50, height: 50)), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupUserInterface() {
        addSubview(uiDismissButton)
        uiDismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        uiDismissButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        uiDismissButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        uiDismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        var urlString = episode?.imageUrl ?? ""
        if !urlString.contains("https") {
            urlString = urlString.replacingOccurrences(of: "http", with: "https")
        }
        
        guard let imageUrl = URL(string: urlString) else { return }
        
        addSubview(uiImageView)
        let viewWidth = frame.width * 0.65
        uiImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "appicon"))
        uiImageView.topAnchor.constraint(equalTo: uiDismissButton.bottomAnchor, constant: 25).isActive = true
        uiImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        uiImageView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
        uiImageView.heightAnchor.constraint(equalToConstant: viewWidth).isActive = true
        
        addSubview(uiTimeSlider)
        uiTimeSlider.topAnchor.constraint(equalTo: uiImageView.bottomAnchor, constant: 25).isActive = true
        uiTimeSlider.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        uiTimeSlider.widthAnchor.constraint(equalToConstant: frame.width*0.8).isActive = true
        uiTimeSlider.heightAnchor.constraint(equalToConstant: uiTimeSlider.frame.height).isActive = true
        
        addSubview(uiTimePlayedLabel)
        uiTimePlayedLabel.topAnchor.constraint(equalTo: uiTimeSlider.bottomAnchor, constant: 0).isActive = true
        uiTimePlayedLabel.leftAnchor.constraint(equalTo: uiTimeSlider.leftAnchor).isActive = true
        uiTimePlayedLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        uiTimePlayedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(uiTimeLeftLabel)
        uiTimeLeftLabel.topAnchor.constraint(equalTo: uiTimeSlider.bottomAnchor, constant: 0).isActive = true
        uiTimeLeftLabel.rightAnchor.constraint(equalTo: uiTimeSlider.rightAnchor).isActive = true
        uiTimeLeftLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        uiTimeLeftLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(uiTitleLabel)
        uiTitleLabel.topAnchor.constraint(equalTo: uiTimePlayedLabel.bottomAnchor, constant: -10).isActive = true
        uiTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        uiTitleLabel.widthAnchor.constraint(equalToConstant: frame.width*0.8).isActive = true
        uiTitleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        uiTitleLabel.text = episode?.title
        
        addSubview(uiSkipBackButton)
        uiSkipBackButton.topAnchor.constraint(equalTo: uiTitleLabel.bottomAnchor, constant: 0).isActive = true
        uiSkipBackButton.leftAnchor.constraint(equalTo: uiTimeSlider.leftAnchor, constant: 10).isActive = true
        uiSkipBackButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        uiSkipBackButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(uiPlayButton)
        uiPlayButton.topAnchor.constraint(equalTo: uiTitleLabel.bottomAnchor, constant: 0).isActive = true
        uiPlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        uiPlayButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        uiPlayButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(uiSkipForwardButton)
        uiSkipForwardButton.topAnchor.constraint(equalTo: uiTitleLabel.bottomAnchor, constant: 0).isActive = true
        uiSkipForwardButton.rightAnchor.constraint(equalTo: uiTimeSlider.rightAnchor, constant: -10).isActive = true
        uiSkipForwardButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        uiSkipForwardButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.4, animations: {
            self.frame.origin.y += self.frame.size.height
        }) { (success) in
            self.removeFromSuperview()
        }
    }
}
