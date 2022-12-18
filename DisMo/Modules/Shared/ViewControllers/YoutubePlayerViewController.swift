//
//  YoutubePlayerViewController.swift
//  DisMo
//
//  Created by Jehnsen Hirena Kane on 17/12/22.
//

import UIKit
import WebKit



class YoutubePlayerViewController: UIViewController {
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    let videoId: String
    
    init(videoId: String)  {
        self.videoId = videoId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        loadYoutubeVideo()
    }

    private func setupLayout() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadYoutubeVideo() {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoId)") else {
            self.popupAlert(title: "Error",
                            message: "Wrong video url, please try again later")
            return
        }
        webView.load(URLRequest(url: url))
    }
}
