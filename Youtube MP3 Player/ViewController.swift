//
//  ViewController.swift
//  Youtube MP3 Player
//
//  Created by Moazzam Tahir on 02/09/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import UIKit
import WebKit
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
            print("loaded URL: \(url)")
        }
        
    }
    
    @IBAction func playVideo(_ sender: Any) {
        
        guard let url = URL(string: urlLink) else {
            fatalError("URL not found ")
        }
        
        self.extractYoutubeLink(youtubeLink: url) { (link, error) in
            guard let url = URL(string: link!) else {
                fatalError(error!.localizedDescription)
            }
        }
        
    }
    
    func extractYoutubeLink(youtubeLink url: URL, getLink: @escaping (String?, Error?) -> Void) {
        let extractor = YoutubeDirectLinkExtractor()
        
        extractor.extractInfo(for: .url(url), success: { (info) in
            getLink(info.lowestQualityPlayableLink, nil)
        }) { (error) in
            getLink(nil, error)
        }
        
    }
    
}


