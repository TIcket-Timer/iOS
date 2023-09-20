//
//  CalendarViewController.swift
//  iOS-TicketTimer
//
//  Created by Jinhyung Park on 2023/08/02.

//FSCalendar
//Lottie Animation
//Swagger UI

import UIKit
import Foundation
import FSCalendar

//class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
//
//    fileprivate weak var fsCalendar: FSCalendar!
//
//    override func loadView() {
//        let view = UIView(frame: UIScreen.main.bounds)
//        self.view = view
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let fsCalendar = FSCalendar(frame: CGRect(x: 20, y: 30, width: 320, height: 400))
//        fsCalendar.dataSource = self
//        fsCalendar.delegate = self
//        view.addSubview(fsCalendar)
//        self.fsCalendar = fsCalendar
//    }
//}

final class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
        
    //Property ( 클로저로 선언 )
    private var fscalendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.headerHeight = 50
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20)
        calendar.appearance.weekdayTextColor = .black
        calendar.placeholderType = .none
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        return calendar
    }()
    
    //ViewCycle
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        self.view = view
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fscalendar.dataSource = self
        fscalendar.delegate = self
        
        view.addSubview(fscalendar)
    
        NSLayoutConstraint.activate([
            self.fscalendar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.fscalendar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.fscalendar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.fscalendar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.fscalendar.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -350)
        ])
        
    }
    
    //    private lazy var scrollView = UIScrollView()
    //    private lazy var contentView = UIView()
    //    private lazy var titleLabel = UILabel()
    //    private lazy var previousButton = UIButton()
    //    private lazy var nextButton = UIButton()
    //    private lazy var weekStackView = UIStackView()
    //    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    //
    //    private func configure() {
    //        self.configureScrollView()
    //        self.configureContentView()
    //        self.configureTitleLabel()
    //        self.configurePreviousButton()
    //        self.configureNextButton()
    //        self.configureWeekStackView()
    //        self.configureWeekLabel()
    //        self.configureCollectionView()
    //    }
    //
    //    private func configureScrollView() {
    //        self.view.addSubview(self.scrollView)
    //        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
    //            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
    //            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
    //            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    //        ])
    //    }
    //
    //    private func configureContentView() {
    //        self.scrollView.addSubview(self.contentView)
    //        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            self.contentView.topAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.topAnchor),
    //            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.leadingAnchor),
    //            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.trailingAnchor),
    //            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.bottomAnchor),
    //            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
    //        ])
    //    }
    //
    //    private func configureTitleLabel() {
    //        self.contentView.addSubview(self.titleLabel)
    //        self.titleLabel.text = "2000년 01월"
    //        self.titleLabel.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
    //        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
    //            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
    //        ])
    //    }
    //
    //    private func configurePreviousButton() {
    //        self.contentView.addSubview(self.previousButton)
    //        self.previousButton.tintColor = .label
    //        self.previousButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    //        self.previousButton.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            self.previousButton.heightAnchor.constraint(equalToConstant: 44),
    //            self.previousButton.widthAnchor.constraint(equalToConstant: 44),
    //            self.previousButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50),
    //            self.previousButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
    //        ])
    //    }
    //
    //    private func configureNextButton() {
    //        self.contentView.addSubview(self.nextButton)
    //        self.nextButton.tintColor = .label
    //        self.nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    //        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            self.nextButton.heightAnchor.constraint(equalToConstant: 44),
    //            self.nextButton.widthAnchor.constraint(equalToConstant: 44),
    //            self.nextButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
    //            self.nextButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
    //        ])
    //    }
    //
    //    private func configureWeekStackView() {
    //        self.contentView.addSubview(self.weekStackView)
    //        self.weekStackView.distribution = .fillEqually
    //        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            self.weekStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
    //            self.weekStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
    //            self.weekStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5)
    //        ])
    //    }
    //
    //    private func configureWeekLabel() {
    //        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
    //
    //        for i in 0..<7 {
    //            let label = UILabel()
    //            label.text = dayOfTheWeek[i]
    //            label.textAlignment = .center
    //            self.weekStackView.addArrangedSubview(label)
    //
    //            if i == 0 {
    //                label.textColor = .systemRed
    //            } else if i == 6 {
    //                label.textColor = .systemBlue
    //            }
    //        }
    //    }
    //
    //    private func configureCollectionView() {
    //        self.contentView.addSubview(self.collectionView)
    //        self.collectionView.dataSource = self
    //        self.collectionView.delegate = self
    //        self.collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
    //        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
    //        NSLayoutConstraint.activate([
    //            self.collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor, constant: 10),
    //            self.collectionView.leadingAnchor.constraint(equalTo: self.weekStackView.leadingAnchor),
    //            self.collectionView.trailingAnchor.constraint(equalTo: self.weekStackView.trailingAnchor),
    //            self.collectionView.heightAnchor.constraint(equalTo: self.collectionView.widthAnchor, multiplier: 1.5),
    //            self.collectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    //        ])
    //    }
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        self.view.backgroundColor = .systemBackground
    //        self.configure()
    //    }
    //}
    //
    //extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //
    //    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //        return 42
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.identifier, for: indexPath) as? CalendarCell else {
    //            return UICollectionViewCell()
    //        }
    //        return cell
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        let width = self.weekStackView.frame.width / 7
    //        return CGSize(width: width, height: width)
    //    }
    //
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return .zero
    //    }
    //}
    
}
