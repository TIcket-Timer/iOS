//
//  PrivacyPolicyViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/31.
//

import UIKit
import SnapKit
import WebKit

class PrivacyPolicyViewController: UIViewController, WKNavigationDelegate {
    
    private let webConfiguration = WKWebViewConfiguration()
    private lazy var webView = WKWebView(frame: .zero, configuration: webConfiguration)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .white
        
        guard let filePath = Bundle.main.path(forResource: "개인정보 처리방침", ofType: "html") else {
            print("filePath error")
            return
        }
        let url = URL(fileURLWithPath: filePath)
        let request = URLRequest(url: url)
        
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension PrivacyPolicyViewController {
    private func setLayout() {
        self.view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
