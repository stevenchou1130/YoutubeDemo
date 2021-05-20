//
//  BMPlayerDemoViewController.swift
//  YoutubeDemo
//
//  Created by Steven on 2021/5/10.
//

import UIKit
import XCDYouTubeKit
import BMPlayer

class BMPlayerDemoViewController: UIViewController {
    
    var currentState: BMPlayerState?
    
    let playerController = BMPlayerControlView()
    
    lazy var player: BMPlayer = {
        let player = BMPlayer(customControllView: self.playerController)
        self.playerController.backButton.isHidden = true
        BMPlayerConf.animateDelayTimeInterval = 1
        BMPlayerConf.shouldAutoPlay = false
        BMPlayerConf.enableChooseDefinition = false
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        
        let playerW = self.view.frame.width - (16 * 2)
        let playerH = playerW * (9 / 16)
        self.view.addSubview(self.player)
        self.player.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(16)
            make.top.equalTo(self.view).offset(80)
            make.width.equalTo(playerW)
            make.height.equalTo(playerH)
        }
        
        self.player.delegate = self
        
        self.player.playOrientChanged = { (isFullScreen) in
            
        }
        
        self.configVideo(with: "hWWw-06ebkY")
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
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
            
            let asset = BMPlayerResource(url: url)
            self.player.setVideo(resource: asset)
            self.player.play()
        }
    }
}

extension BMPlayerDemoViewController: BMPlayerDelegate {
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("=== playerIsPlaying: \(playing)")
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        if isFullscreen {
            player.snp.remakeConstraints { (make) in
                make.top.equalTo(view.snp.top)
                make.left.equalTo(view.snp.left)
                make.right.equalTo(view.snp.right)
                make.bottom.equalTo(view.snp.bottom)
            }
        } else {
            let playerW = self.view.frame.width - (16 * 2)
            let playerH = playerW * (9 / 16)
            player.snp.remakeConstraints { (make) in
                make.leading.equalTo(self.view).offset(16)
                make.top.equalTo(self.view).offset(80)
                make.width.equalTo(playerW)
                make.height.equalTo(playerH)
            }
        }
    }
    
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        print("=== playerStateDidChange: \(state)")
        
        self.currentState = state
    }
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        //
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        
        if self.currentState == .readyToPlay {
            print("=== playTimeDidChange: \(currentTime)")
        }
    }
}
