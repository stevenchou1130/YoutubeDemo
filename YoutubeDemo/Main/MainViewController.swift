//
//  MainViewController.swift
//  YoutubeDemo
//
//  Created by Steven on 2021/4/13.
//

import UIKit
import youtube_ios_player_helper

class MainViewController: UIViewController {
    
    @IBOutlet weak var videoContainerView: UIView!
    
    var videoSize: CGSize {
        return self.videoContainerView.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        
        let frame = CGRect(x: 0, y: 0, width: self.videoSize.width, height: self.videoSize.height)
        let playerView = YTPlayerView(frame: frame)
        playerView.delegate = self

        // https://developers.google.com/youtube/player_parameters?playerVersion=HTML5#Parameters
        let playerVars: [AnyHashable: Any] = ["modestbranding": 1, "playsinline": 1, "autoplay": 1, "showinfo": 0]
        playerView.load(withVideoId: "DQ7HSI5VeB4", playerVars: playerVars)

        self.videoContainerView.addSubview(playerView)
    }
}

extension MainViewController: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        print("=== playerViewDidBecomeReady")
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
        print("=== didChangeToState: \(state.rawValue)")
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        
        print("=== didChangeToQuality: \(quality.rawValue)")
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        
        print("=== didPlayTime: \(playTime)")
    }
}
