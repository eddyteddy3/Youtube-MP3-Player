//
//  ViewController.swift
//  Youtube MP3 Player
//
//  Created by Moazzam Tahir on 02/09/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import AVKit
import YoutubeDirectLinkExtractor

class ViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var textView: UITextField!
    
    let urlLink = "https://www.youtube.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openLink()
    }

    func openLink() {
        guard let url = URL(string: urlLink) else {
            fatalError("URL not found ")
        }
        
        if let myWebView = webView {
            let request = URLRequest(url: url)
            myWebView.load(request)
        }
        
    }
    
    //total length of youtube link is 16 or 17
    
    @IBAction func playVideo(_ sender: Any) {
        
        var videoId = textView.text!
        videoId.removeFirst(17)
        
        self.extractYoutubeLink(videoID: videoId) { (link, error) in
            guard let url = URL(string: link!) else {
                fatalError(error!.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.playURL(VideoURL: url)
            }
        }
        
    }
    
    func playURL(VideoURL url: URL) {
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        
        controller.player = player
        
        present(controller, animated: true) {
            player.play()
        }
    }
    
    func extractYoutubeLink(videoID id: String, getLink: @escaping (String?, Error?) -> Void) {
        let extractor = YoutubeDirectLinkExtractor()
        
        extractor.extractInfo(for: .id(id), success: { (info) in
            getLink(info.highestQualityPlayableLink, nil)
        }) { (error) in
            getLink(nil, error)
        }
        
    }
    
}


