//
//  TutorialViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class TutorialNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let appearance = UINavigationBarAppearance()
            
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
    }
}

class TutorialViewController: UIViewController {
    
    let tabBar: UITabBar
    
    private let homeIcon = UIImageView()
    private let homeArrow = UIImageView()
    private let homeText = UILabel()
    
    private let ticketIcon = UIImageView()
    private let ticketArrow = UIImageView()
    private let ticketText = UILabel()
    
    private let calendarIcon = UIImageView()
    private let calendarArrow = UIImageView()
    private let calendarText = UILabel()
    
    var cancleButton = UIBarButtonItem()
    
    private let disposeBag = DisposeBag()
    
    init(_ tabBar: UITabBar) {
        self.tabBar = tabBar
        super.init(nibName: nil, bundle: nil)
        setAtt()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAtt() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        homeIcon.image = UIImage(named: "houseWhite")
        ticketIcon.image = UIImage(named: "ticketWhite")
        calendarIcon.image = UIImage(named: "calendarWhite")
        
        homeArrow.image = UIImage(named: "houseVector")
        ticketArrow.image = UIImage(named: "ticketVector")
        calendarArrow.image = UIImage(named: "calendarVector")

        let baseAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: UIColor.white
        ]
        let colorAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13, weight: .medium),
            .foregroundColor: UIColor.mainColor,
        ]
        
        let homeAtt = NSMutableAttributedString(string: "캘린더, 임박한 예매 일정,\n공연 오픈 소식과 같은\n", attributes: baseAtt)
        homeAtt.append(NSAttributedString(string: "종합적인 내용", attributes: colorAtt))
        homeAtt.append(NSAttributedString(string: "을 볼 수 있어요.", attributes: baseAtt))
        homeText.attributedText = homeAtt
        homeText.numberOfLines = 0
        homeText.textAlignment = .left
        
        let ticketAtt = NSMutableAttributedString(string: "예매하려는 공연을 검색하고\n", attributes: baseAtt)
        ticketAtt.append(NSAttributedString(string: "예매일정 알람을 추가", attributes: colorAtt))
        ticketAtt.append(NSAttributedString(string: "할 수 있어요.", attributes: baseAtt))
        ticketText.attributedText = homeAtt
        ticketText.numberOfLines = 0
        ticketText.textAlignment = .left
        
        let calendarAtt = NSMutableAttributedString(string: "캘린더에 ", attributes: baseAtt)
        calendarAtt.append(NSAttributedString(string: "메모를 작성", attributes: colorAtt))
        calendarAtt.append(NSAttributedString(string: "하거나\n", attributes: baseAtt))
        calendarAtt.append(NSAttributedString(string: "예매 알람을 수정", attributes: colorAtt))
        calendarAtt.append(NSAttributedString(string: "할 수 있어요.", attributes: baseAtt))
        calendarText.attributedText = calendarAtt
        calendarText.numberOfLines = 0
        calendarText.textAlignment = .left
        
        cancleButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: nil)
        cancleButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = cancleButton
    }
    
    private func setLayout() {
        view.addSubviews([
            homeIcon, homeArrow, homeText,
            ticketIcon, ticketArrow, ticketText,
            calendarIcon, calendarArrow, calendarText
        ])
        
        let tabBarHeight = tabBar.frame.height
        let tabBarTopMargin: CGFloat = 7
        let iconHeight: CGFloat = 24
        let iconCenterY = -tabBarHeight + tabBarTopMargin + iconHeight
        
        let tabBarItemWidth = tabBar.bounds.width / CGFloat(tabBar.items?.count ?? 0)
        let tabBarWidthHalf = tabBar.frame.width / 2
        let HomeCenterX = (0 + 0.5) * tabBarItemWidth - tabBarWidthHalf
        let ticketCenterX = (1 + 0.5) * tabBarItemWidth - tabBarWidthHalf
        let calendarCenterX = (2 + 0.5) * tabBarItemWidth - tabBarWidthHalf
        
        homeIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(HomeCenterX)
            make.bottom.equalToSuperview().offset(iconCenterY)
            make.width.height.equalTo(iconHeight)
        }
        ticketIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(ticketCenterX)
            make.bottom.equalToSuperview().offset(iconCenterY)
            make.width.height.equalTo(iconHeight)
        }
        calendarIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(calendarCenterX)
            make.bottom.equalToSuperview().offset(iconCenterY)
            make.width.height.equalTo(iconHeight)
        }
        
        
        homeArrow.snp.makeConstraints { make in
            make.centerX.equalTo(homeIcon.snp.centerX)
            make.bottom.equalTo(homeIcon.snp.top).offset(-6)
        }
        ticketArrow.snp.makeConstraints { make in
            make.centerX.equalTo(ticketIcon.snp.centerX)
            make.bottom.equalTo(ticketIcon.snp.top).offset(-6)
        }
        calendarArrow.snp.makeConstraints { make in
            make.centerX.equalTo(calendarIcon.snp.centerX)
            make.bottom.equalTo(calendarIcon.snp.top).offset(-6)
        }
        
        homeText.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.bottom.equalTo(homeArrow.snp.top).offset(-10)
        }
        ticketText.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(79)
            make.bottom.equalTo(ticketArrow.snp.top).offset(-10)
        }
        calendarText.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(calendarArrow.snp.top).offset(-10)
        }
    }
}
