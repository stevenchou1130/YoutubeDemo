//
//  PlayerDemoViewController.swift
//  YoutubeDemo
//
//  Created by Steven on 2021/3/31.
//

import UIKit
import AVKit
import XCDYouTubeKit
import YouTubePlayer
import youtube_ios_player_helper

class PlayerDemoViewController: UIViewController {

    @IBOutlet weak var videoContainerView: UIView!
    
    var videoSize: CGSize {
        return self.videoContainerView.frame.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.playVideoViaPlayerHelper()
    }
    
    @IBAction func getClipboardContent(_ sender: Any) {
        if let pasteboardString = UIPasteboard.general.string {
            print("String is \(pasteboardString)")
        } else {
            print("Nothing in pasteboard")
        }
    }
}

// MARK: - youtube_ios_player_helper
// https://github.com/youtube/youtube-ios-player-helper
extension PlayerDemoViewController: YTPlayerViewDelegate {
    
    func playVideoViaPlayerHelper() {

        let frame = CGRect(x: 0, y: 0, width: self.videoSize.width, height: self.videoSize.height)
        let playerView = YTPlayerView(frame: frame)
        playerView.delegate = self

        // https://developers.google.com/youtube/player_parameters?playerVersion=HTML5#Parameters
        let playerVars: [AnyHashable: Any] = ["modestbranding": 1, "playsinline": 1, "autoplay": 1]
        playerView.load(withVideoId: "DQ7HSI5VeB4", playerVars: playerVars)

        self.videoContainerView.addSubview(playerView)
    }
}

// MARK: - YouTubePlayer
// https://github.com/gilesvangruisen/Swift-YouTube-Player
extension PlayerDemoViewController {
    
    func playVideoViaYouTubePlayer() {

        let frame = CGRect(x: 0, y: 0, width: self.videoSize.width, height: self.videoSize.height)
        let videoPlayer = YouTubePlayerView(frame: frame)
        
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
extension PlayerDemoViewController {

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
