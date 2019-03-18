//
//  WebViewController.swift
//  MobPushDemoSwift
//
//  Created by LeeJay on 2019/1/25.
//  Copyright © 2019 YouZu. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView.delegate = self
        
        guard let urlStr = url else {
            return
        }
        guard let _url = URL.init(string: urlStr) else {
            return
        }
        
        webView.loadRequest(URLRequest.init(url: _url))
    }
}
