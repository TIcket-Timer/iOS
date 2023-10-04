//
//  HomeViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import SnapKit
import FSCalendar

class HomeViewController: UIViewController {
    
    private lazy var topBgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 130))
    private let logoImageView = UIImageView()
    private let calendarView = UIView()
    private lazy var calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 48, height: self.view.frame.width - 46))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
    }
    
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = .white
        self.view.addSubviews([topBgView, calendarView])
        topBgView.addSubview(logoImageView)
        calendarView.addSubview(calendar)
    
        let gradient = CAGradientLayer()
        gradient.frame = topBgView.bounds
        gradient.colors = [UIColor("#00D090").cgColor, UIColor("#0AB27E").cgColor]
        topBgView.layer.insertSublayer(gradient, at: 0)
        topBgView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        logoImageView.image = UIImage(named: "homeLogo")
        
        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 10
        calendarView.layer.masksToBounds = false
        calendarView.layer.shadowColor = UIColor.black.cgColor
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 4)
        calendarView.layer.shadowOpacity = 0.2
        calendarView.layer.shadowRadius = 10.0
        
        calendar.dataSource = self
        calendar.delegate = self
        
    }
    
    private func setAutoLayout() {
        topBgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(35)
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(topBgView.snp.bottom).offset(-13)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.width.height.equalTo(self.view.frame.width - 48)
        }
    }
}

extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        
        self.view.layoutIfNeeded()
    }
}
