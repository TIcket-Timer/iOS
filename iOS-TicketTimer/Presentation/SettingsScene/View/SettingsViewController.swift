//
//  SettingsViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class SettingsViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = SettingsViewModel()
    private lazy var input = SettingsViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    let mypage = SettingDetail(title: "마이페이지")
    let divider1 = UIView()

    let alarm = SettingDetail(title: "알람 설정")
    let useInfo = SettingDetail(title: "이용 안내")

    let deleteAccountLabel = UILabel()
    let signOutLabel = UILabel()
    let divider2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "설정"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
 
    private func setGesture() {
        mypage.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let vc = MypageViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        alarm.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let vc = AlarmConfigureViewController()
                let nav = BottomSheetNavigationController(rootViewController: vc, heigth: 390)
                self?.present(nav, animated: true)
            }
            .disposed(by: disposeBag)
        
        useInfo.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let vc = UseInfoViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        //MARK: - 회원탈퇴
        
        deleteAccountLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let alertController = UIAlertController(title: "회원탈퇴", message: "정말로 탈퇴를 하시겠습니까?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let confirmAction = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
                    //TODO: - 회원 탈퇴
                    print("회원 탈퇴")
                }
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                self?.present(alertController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        //MARK: - 로그아웃
        
        signOutLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                    self?.input.logout.onNext(())
                }
                alertController.addAction(cancelAction)
                alertController.addAction(confirmAction)
                self?.present(alertController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        output.logoutSuccess
            .subscribe(onNext: { success in
                if success {
                    let vc = LoginViewController()
                    PresentationManager.shared.changeRootVC(vc)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        
        divider1.backgroundColor = UIColor("#F9F9F9")
        
        deleteAccountLabel.setup(text: "회원 탈퇴", color: .black, size: 17, weight: .regular)
        signOutLabel.setup(text: "로그아웃", color: .black, size: 17, weight: .regular)
        divider2.backgroundColor = UIColor("#F9F9F9")
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([mypage, alarm, useInfo, divider1, deleteAccountLabel, signOutLabel, divider2])
        
        mypage.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        divider1.snp.makeConstraints { make in
            make.top.equalTo(mypage.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        alarm.snp.makeConstraints { make in
            make.top.equalTo(divider1.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        useInfo.snp.makeConstraints { make in
            make.top.equalTo(alarm.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        divider2.snp.makeConstraints { make in
            make.top.equalTo(useInfo.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        deleteAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(divider2.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }

        signOutLabel.snp.makeConstraints { make in
            make.top.equalTo(deleteAccountLabel.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
}

class SettingDetail: UIView {
    
    private let title: String
    
    private let titleLabel = UILabel()
    private let spacer = UIView()
    private let arrowImageView = UIImageView()
    private lazy var stackView = UIStackView(arrangedSubviews: [titleLabel, spacer, arrowImageView])
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        titleLabel.setup(text: title, color: .black, size: 17, weight: .regular)
        
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .gray60
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
