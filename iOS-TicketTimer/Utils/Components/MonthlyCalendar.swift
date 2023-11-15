//
//  MonthlyCalendar.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import FSCalendar

class MonthlyCalendar: UIView {
    
    private let disposeBag = DisposeBag()
    
    var monthlyCalendar = FSCalendar()
    
    private let prevButton = UIButton()
    private let nextButton = UIButton()
    private var dateComponents = DateComponents()
    private lazy var currentPage: Date = self.monthlyCalendar.currentPage
    
    weak var delegate: FSCalendarDelegate? {
        didSet {
            monthlyCalendar.delegate = delegate
        }
    }
    weak var dataSource: FSCalendarDataSource? {
        didSet {
            monthlyCalendar.dataSource = dataSource
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func moveCalendarPage(moveUp: Bool) {
        self.dateComponents.month = moveUp ? 1 : -1
        guard let today = monthlyCalendar.today else { return }
        self.currentPage = Calendar(identifier: .gregorian).date(byAdding: dateComponents, to: self.currentPage) ?? today
        self.monthlyCalendar.setCurrentPage(self.currentPage, animated: true)
    }
    
    private func configure() {
        monthlyCalendar.backgroundColor = .white
        monthlyCalendar.layer.cornerRadius = 10
        
        // Header
        monthlyCalendar.appearance.headerDateFormat = "YYYY년 M월"
        monthlyCalendar.appearance.headerTitleAlignment = .left
        monthlyCalendar.appearance.headerTitleOffset = .init(x: -72, y: 0)
        monthlyCalendar.appearance.headerTitleFont = .systemFont(ofSize: 17, weight: .bold)
        monthlyCalendar.appearance.headerTitleColor = .gray100
        monthlyCalendar.appearance.headerMinimumDissolvedAlpha = 0.0 // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
        
        // Weekday
        monthlyCalendar.locale = Locale(identifier: "ko_KR")
        monthlyCalendar.appearance.weekdayFont = .systemFont(ofSize: 15, weight: .medium)
        monthlyCalendar.appearance.weekdayTextColor = .gray60
        
        // Day
        monthlyCalendar.appearance.titleFont = .systemFont(ofSize: 20, weight: .regular)
        monthlyCalendar.appearance.todayColor = .mainColor
        monthlyCalendar.appearance.titleTodayColor = .white
        monthlyCalendar.appearance.selectionColor = .subGreenColor
        monthlyCalendar.appearance.titleSelectionColor = .mainColor
        monthlyCalendar.appearance.eventDefaultColor = .mainColor
        monthlyCalendar.appearance.eventSelectionColor = .mainColor
        monthlyCalendar.placeholderType = .none
        
        addSubview(monthlyCalendar)
        monthlyCalendar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        prevButton.setImage(UIImage(named: "prev"), for: .normal)
        nextButton.setImage(UIImage(named: "next"), for: .normal)
        
        monthlyCalendar.addSubviews([prevButton, nextButton])
        nextButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview()
            make.width.equalTo(15)
            make.height.equalTo(24)
        }
        prevButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(nextButton.snp.leading).offset(-24)
            make.width.equalTo(15)
            make.height.equalTo(24)
        }
        
        prevButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (self, _) in
                self.moveCalendarPage(moveUp: false)
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (self, _) in
                self.moveCalendarPage(moveUp: true)
            })
            .disposed(by: disposeBag)
    }
}
