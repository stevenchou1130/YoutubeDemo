//
//  MainViewController.swift
//  YoutubeDemo
//
//  Created by Steven on 2021/3/31.
//

import UIKit
import AVKit
import XCDYouTubeKit
import YouTubePlayer
import youtube_ios_player_helper

class MainViewController: UIViewController {

    @IBOutlet weak var videoContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        
        self.playVideoViaPlayerHelper()
    }
}

// MARK: - youtube_ios_player_helper
// https://github.com/youtube/youtube-ios-player-helper
extension MainViewController: YTPlayerViewDelegate {
    
    func playVideoViaPlayerHelper() {

        let playerView = YTPlayerView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        playerView.delegate = self

        // https://developers.google.com/youtube/player_parameters?playerVersion=HTML5#Parameters
        let playerVars: [AnyHashable: Any] = ["modestbranding": 1, "playsinline": 1, "autoplay": 1]
        playerView.load(withVideoId: "DQ7HSI5VeB4", playerVars: playerVars)

        self.videoContainerView.addSubview(playerView)
    }
}

// MARK: - YouTubePlayer
// https://github.com/gilesvangruisen/Swift-YouTube-Player
extension MainViewController {
    
    func playVideoViaYouTubePlayer() {

        let playerFrame = CGRect(x: 0, y: 0, width: 300, height: 200)
        let videoPlayer = YouTubePlayerView(frame: playerFrame)
        
        // https://developers.google.com/youtube/player_parameters?playerVersion=HTML5#Parameters
        videoPlayer.playerVars["modestbranding"] = 1 as AnyObject?
        videoPlayer.playerVars["playsinline"] = 1 as AnyObject?
        videoPlayer.playerVars["autoplay"] = 1 as AnyObject?
        videoPlayer.loadVideoID("GYGIVAb5s4U")
        
        self.videoContainerView.addSubview(videoPlayer)
    }
}

// MARK: - XCDYouTubeKit
// https://github.com/0xced/XCDYouTubeKit
extension MainViewController {

    func playVideoViaXCDYouTubeKit() {

        // Full Screen
        let playerVC = AVPlayerViewController()

        XCDYouTubeClient.default().getVideoWithIdentifier("GYGIVAb5s4U") { [weak self] (video, error) in

            if let video = video {

                let streamURLs = video.streamURLs

                guard let url = streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] else {
                    print("=== Can not access url")
                    return
                }

                print("=== Video's url: \(url)")

                playerVC.player = AVPlayer(url: url)

                self?.present(playerVC, animated: true) {
                    print("=== Start play video")
                    playerVC.player?.play()
                }
            }
        }

        /*
        // Inline
        // Reference: Demo app (https://github.com/0xced/XCDYouTubeKit/tree/master/XCDYouTubeKit%20Demo)
        XCDYouTubeClient.default().getVideoWithIdentifier("TkGGmkPi_ks") { (video, error) in

            if let video = video {

                let playerVC = AVPlayerViewController()
                playerVC.updatesNowPlayingInfoCenter = false

                guard let url = video.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] else {
                    print("=== Can not access url")
                    return
                }

                print("=== Video's url: \(url)")

                playerVC.player = AVPlayer(url: url)
                playerVC.view.frame = self.videoContainerView.bounds
                self.addChild(playerVC)

                self.videoContainerView.addSubview(playerVC.view)

                playerVC.didMove(toParent: self)

                playerVC.player?.play()

            } else {

                print("=== NO video, error: \(error)")
            }
        }
        */
    }
}
