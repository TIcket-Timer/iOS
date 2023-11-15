//
//  AddMemoViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources
import FSCalendar

class AddMemoViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: CalendarViewModel
    private lazy var input = viewModel.input
    private lazy var output = viewModel.output
    
    var id: Int?
    
    private let calendar = MonthlyCalendar()
    private let calendarView = UIView()
    
    private let sheetView = UIView()
    private let memoLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentBgView = UIView()
    private let textView = UITextView()
    
    private let cancelButton = UIButton()
    private let completeButton = UIButton()
    private lazy var ButtonStackView = UIStackView(arrangedSubviews: [cancelButton, completeButton])
    
    init(
        viewModel: CalendarViewModel = CalendarViewModel(),
        id: Int? = nil
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        if let id = id {
            self.input.getMemo.onNext(id)
            self.id = id
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setLayout()
        input.setDateString.onNext(Date())
        output.bindMemo
            .subscribe(onNext: { [weak self] memo in
                self?.textView.text = memo.content
                self?.dateLabel.text = memo.date?.toString(inputFormat: "yyyy-MM-dd", outputFormat: "yyyy년 M월 d일 (E)")
                
                let date = memo.date?.toDate("yyyy-MM-dd") ?? Date()
                self?.calendar.monthlyCalendar.select(date)
                self?.calendar.monthlyCalendar.setCurrentPage(date, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func setAttribute() {
        view.backgroundColor = .lightGray
        
        navigationItem.title = "메모"
        
        calendar.delegate = self
        calendar.dataSource = self
        
        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 10

        sheetView.backgroundColor = .white
        sheetView.layer.cornerRadius = 10
        
        memoLabel.setup(text: "메모", color: .gray100, size: 17, weight: .bold)
        dateLabel.setup(text: "날짜", color: .gray100, size: 17, weight: .medium)
        output.bindDate
            .subscribe(onNext: { [weak self] date in
                self?.dateLabel.text = date
            })
            .disposed(by: disposeBag)
        
        contentBgView.backgroundColor = .gray10
        contentBgView.layer.cornerRadius = 10
        
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textColor = .gray100
        textView.backgroundColor = .clear
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.gray80, for: .normal)
        cancelButton.backgroundColor = .gray20
        cancelButton.layer.cornerRadius = 10
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = .mainColor
        completeButton.layer.cornerRadius = 10
        
        ButtonStackView.axis = .horizontal
        ButtonStackView.distribution = .fillEqually
        ButtonStackView.spacing = 24
        
        cancelButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
                
                let date = dateLabel.text?.toString(inputFormat: "yyyy년 M월 d일 (E)", outputFormat: "yyyyMMdd") ?? "20000101"
                let content = textView.text ?? ""
                let memo = Memo(id: id, date: date, content: content)
                if let id = self.id {
                    input.updateMemo.onNext(memo)
                } else {
                    input.addMemo.onNext((content, date))
                }
            }
            .disposed(by: disposeBag)
    }
}

extension AddMemoViewController {
    private func setLayout() {
        self.view.addSubviews([calendarView, sheetView])
        calendarView.addSubview(calendar)
        sheetView.addSubviews([memoLabel, dateLabel, contentBgView, ButtonStackView])
        contentBgView.addSubview(textView)
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(340)
        }
        calendar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(340)
        }
        
        sheetView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom).offset(60)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        ButtonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(48)
        }
        
        contentBgView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(ButtonStackView.snp.top).offset(-12)
        }
        textView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
    }
}

extension AddMemoViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(200)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        input.setDateString.onNext(date)
    }
}
