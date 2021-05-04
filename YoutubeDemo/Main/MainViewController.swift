//
//  MainViewController.swift
//  YoutubeDemo
//
//  Created by Steven on 2021/5/4.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    lazy var videoContainerView: UIView = {
        return UIView(frame: .zero)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        
        let playerW = self.view.frame.width - (16 * 2)
        let playerH = playerW * (9 / 16)
        self.view.addSubview(self.videoContainerView)
        self.videoContainerView.snp.makeConstraints { make in
            make.leading.equalTo(self.view).offset(16)
            make.top.equalTo(self.view).offset(80)
            make.width.equalTo(playerW)
            make.height.equalTo(playerH)
        }
        
        let videoPlayerVC = SCAVPlayerViewController(videoID: "TkGGmkPi_ks")
        videoPlayerVC.playerDelegate = self
        videoPlayerVC.config(parentVC: self, containerView: self.videoContainerView)
    }
}

extension MainViewController: SCAVPlayerDelegate {
    
    func ready(playerVC: SCAVPlayerViewController) {
        // Auto play
         playerVC.play()
    }
}
