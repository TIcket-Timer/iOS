//
//  UseInfoViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class UseInfoViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let tutorialLabel = UILabel()
    private let serviceTermLabel = UILabel()
    private let privacyPolicyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
    }
    
    private func setGesture() {
        tutorialLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                
            }
            .disposed(by: disposeBag)
        
        privacyPolicyLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let vc = PrivacyPolicyViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "이용 안내"
        
        tutorialLabel.setup(text: "튜토리얼 다시보기", color: .black, size: 17, weight: .regular)
        serviceTermLabel.setup(text: "서비스 이용약관", color: .black, size: 17, weight: .regular)
        privacyPolicyLabel.setup(text: "개인정보 처리방침", color: .black, size: 17, weight: .regular)
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([tutorialLabel, serviceTermLabel, privacyPolicyLabel])
        
        tutorialLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        privacyPolicyLabel.snp.makeConstraints { make in
            make.top.equalTo(tutorialLabel.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
//        serviceTermLabel.snp.makeConstraints { make in
//            make.top.equalTo(privacyPolicyLabel.snp.bottom).offset(36)
//            make.leading.equalToSuperview().offset(24)
//            make.trailing.equalToSuperview().offset(-24)
//        }
    }
}

