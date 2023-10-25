//
//  ChangeUsernameViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class ChangeUsernameViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel = SettingsViewModel()
    private lazy var input = SettingsViewModel.Input()
    private var output: SettingsViewModel.Output?
    
    private let textField = UITextField()
    private let container = UIView()
    
    private let cancleButton = UIButton()
    private let divider = UIView()
    private let completeButton = UIButton()
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [cancleButton, divider, completeButton])
    private let buttonContainer = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
        
        output = viewModel.transform(input: input)
    }
    
    private func setGesture() {
        cancleButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
                if let text = self?.textField.text, text != "" {
                    self?.input.updatNickname.accept(text)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "닉네임 설정"
        
        textField.placeholder = "닉네임 변경 내용"
        
        container.backgroundColor = .gray10
        container.layer.cornerRadius = 10
        
        cancleButton.setTitle("취소", for: .normal)
        cancleButton.setTitleColor(.gray100, for: .normal)
        cancleButton.backgroundColor = .clear

        divider.backgroundColor = .gray60
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.mainColor, for: .normal)
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([container, buttonContainer])
        container.addSubview(textField)
        buttonContainer.addSubviews([cancleButton, divider, completeButton])
        
        textField.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.trailing.equalToSuperview().offset(-16)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(50)
        }
        
        divider.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(1)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(divider.snp.leading).offset(-12)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(divider.snp.leading).offset(12)
        }
        
        buttonContainer.snp.makeConstraints { make in
            //make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(container.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(48)
        }
    }
}
