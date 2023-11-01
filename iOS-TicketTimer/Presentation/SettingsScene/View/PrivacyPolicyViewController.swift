//
//  PrivacyPolicyViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/31.
//

import UIKit
import SnapKit

class PrivacyPolicyViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
    }
    
    private func setAttribute() {
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "개인정보 처리방침"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        guard let filePath = Bundle.main.path(forResource: "개인정보 처리방침", ofType: "txt")
        else {
            print("filePath error")
            return
        }
        
        textLabel.text = readTextFile()
        textLabel.numberOfLines = 0
    }
    
    private func readTextFile() -> String {
        var result = ""
        
        guard let pahts = Bundle.main.path(forResource: "개인정보 처리방침.txt", ofType: nil) else {
            print("filePath error")
            return ""
        }
        
        result = try! String(contentsOfFile: pahts, encoding: .utf8)
        
        return result
    }
}

extension PrivacyPolicyViewController {
    private func setLayout() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textLabel)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(5000)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
}
