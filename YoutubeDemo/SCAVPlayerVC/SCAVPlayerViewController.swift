//
//  SCAVPlayerViewController.swift
//  YoutubeDemo
//
//  Created by Steven on 2021/5/4.
//

import UIKit
import AVKit
import XCDYouTubeKit

@objc protocol SCAVPlayerDelegate: AnyObject {
    
    @objc optional func ready(playerVC: SCAVPlayerViewController)
}

@objcMembers class SCAVPlayerViewController: AVPlayerViewController {
    
    // MARK: - Property
    weak var playerDelegate: SCAVPlayerDelegate?
    
    let videoID: String
    
    var isForward: Bool = false
    var playAt: Float = 0.0
    var pauseAt: Float = 0.0
    var seekAt: Float = 0.0 {
        didSet {
            self.isForward = (self.seekAt > self.pauseAt)
        }
    }
    
    // https://stackoverflow.com/questions/42444310/live-search-throttle-in-swift-3
    var seekTask: DispatchWorkItem?
    
    // MARK: - Initialization
    init(videoID: String) {
        self.videoID = videoID
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(Self.self) init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updatesNowPlayingInfoCenter = false
        
        self.configVideo(with: self.videoID)
    }
}

// MARK: - Player Action Handle
extension SCAVPlayerViewController {
    
    private func addObserver(of player: AVPlayer?) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handelSeekAction),
                                               name: .AVPlayerItemTimeJumped,
                                               object: nil)
        player?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        player?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
    }
    
    func handelSeekAction() {
        
        guard let secs = self.player?.currentTime().seconds else {
            return
        }
        
        let seconds = Float(secs)
        self.seekAt = seconds
        self.sendSeekSignal(with: seconds)
    }
    
    func sendSeekSignal(with seconds: Float) {
        
        self.seekTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            // Call API
            print("=== Seek at: \(seconds)")
        }
        self.seekTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !(object as AnyObject? === self.player) {
            return
        }
        
        if (keyPath == "status") {
            switch self.player?.status {
            case .readyToPlay:
                self.playerDelegate?.ready?(playerVC: self)
            default:
                break
            }
        }
        
        if (keyPath == "rate") {
            guard let player = self.player else {
                return
            }
            
            if (player.rate > 0) {
                
                self.seekTask?.cancel()
                
                // Play
                print("=== Play on: \(player.currentTime().seconds)")
                print("=== isForward: \(self.isForward)")
                
            } else {
                // Pause
                print("=== Pause on :\(player.currentTime().seconds)")
                self.pauseAt = Float(player.currentTime().seconds)
            }
        }
    }
}

// MARK: - Public
extension SCAVPlayerViewController {
    
    func config(parentVC: UIViewController, containerView: UIView) {
        parentVC.addChild(self)
        containerView.addSubview(self.view)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        self.didMove(toParent: parentVC)
    }
    
    func play() {
        self.player?.play()
    }
    
    func pause() {
        self.player?.pause()
    }
    
    func seek(to seconds: Float64) {
        self.player?.seek(to: CMTimeMakeWithSeconds(seconds, preferredTimescale: 1000))
    }
}

// MARK: - Private
extension SCAVPlayerViewController {
    
    private func configVideo(with videoID: String) {
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoID) { [unowned self] (video, error) in
            
            if let error = error {
                print("ERROR: NO video, error: \(error)")
                return
            }
            
            guard let video = video else {
                return
            }
            
            guard let url = video.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] else {
                print("ERROR: Can not access url")
                return
            }
            
            self.player = AVPlayer(url: url)
            self.addObserver(of: self.player)
        }
    }
}
