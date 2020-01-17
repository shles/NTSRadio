//
//  ViewController.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 26/11/2017.
//  Copyright © 2017 Shlesberg. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var player: AVPlayer = AVPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://stream-relay-geo.ntslive.net/stream2".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
        let asset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        
        player.volume = 1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var isPlaying = false
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if isPlaying {
            player.pause()
            isPlaying = !isPlaying
        } else {
            player.play()
            isPlaying = !isPlaying
        }
    }
    
}


