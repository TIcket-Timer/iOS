//
//  monthlyCalendarViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources
import FSCalendar

class CalendarViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel = AlarmViewModel()
    private lazy var input = viewModel.input
    private lazy var output = viewModel.output
    
    private let monthlyCalendar = MonthlyCalendar()
    private let monthlyCalendarView = UIView()
    
    private let weeklyCalendar = FSCalendar()
    private let weeklyCalendarView = UIView()
    
    private let divider = UIView()
    
    private let emptyLabel = UILabel()
    private let tableView = UITableView()
    
    private var eventDates: [Date] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setAtt()
        setLayout()
        
        input.getCalendarAllEvent.onNext(())
        input.getCalendarAlarmSections.onNext(Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "캘린더"
    }
    
    private func setAtt() {
        view.backgroundColor = .gray10
        
        setNavigationItem()
        setCalendar()
        
        monthlyCalendarView.backgroundColor = .white
        monthlyCalendarView.layer.cornerRadius = 10
        monthlyCalendarView.layer.masksToBounds = false
        monthlyCalendarView.layer.shadowColor = UIColor.black.cgColor
        monthlyCalendarView.layer.shadowOffset = CGSize(width: 0, height: 2)
        monthlyCalendarView.layer.shadowOpacity = 0.2
        monthlyCalendarView.layer.shadowRadius = 5
        
        divider.backgroundColor = .gray40
        
        emptyLabel.setup(text: "등록된 예매 알람이 없습니다.", color: .gray60, size: 15, weight: .medium)
        
        tableView.register(
            AlarmListTableViewCell.self,
            forCellReuseIdentifier: AlarmListTableViewCell.identifier
        )
        //tableView.rowHeight = 93
        tableView.backgroundColor = .gray10
        tableView.separatorStyle = .none
        
        let dataSource = RxTableViewSectionedReloadDataSource<AlarmSection> {
            dataSource, tableView, indexPath, item  in
            let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.identifier, for: indexPath) as! AlarmListTableViewCell
            cell.cellData.onNext(item)
            cell.selectionStyle = .none
            return cell
        }
        
        output.bindCalendarAlarmSections
            .do(onNext: { [weak self] sections in
                if sections[0].items.isEmpty {
                    self?.setEmptyLayout()
                } else {
                    self?.setTableViewLayout()
                }
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(Alarm.self)
        )
        .subscribe(onNext: { [weak self] indexPath, item in
            guard let self = self else { return }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let vc = AlarmSettingViewController(viewModel: self.viewModel, notice: item.musicalNotice)
            let nav = BottomSheetNavigationController(rootViewController: vc, heigth: 650)
            self.present(nav, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
    
    private func setNavigationItem() {
        let alarmButton = UIImageView(image: UIImage(named: "alarm"))
        let memoButton = UIImageView(image: UIImage(named: "memo"))
        
        let stackview = UIStackView(arrangedSubviews: [alarmButton, memoButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 12
        
        let rightBarButtonItem = UIBarButtonItem(customView: stackview)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        alarmButton.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let vc = AlarmListViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        memoButton.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] _ in
                let vc = MemoListViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setCalendar() {
        monthlyCalendar.dataSource = self
        monthlyCalendar.delegate = self

        weeklyCalendar.dataSource = self
        weeklyCalendar.delegate = self
        weeklyCalendar.scope = .week
        
        weeklyCalendar.headerHeight = 0

        weeklyCalendar.locale = Locale(identifier: "ko_KR")
        weeklyCalendar.appearance.weekdayFont = .systemFont(ofSize: 15, weight: .medium)
        weeklyCalendar.appearance.weekdayTextColor = .gray60

        weeklyCalendar.appearance.titleFont = .systemFont(ofSize: 20, weight: .regular)
        weeklyCalendar.appearance.todayColor = .mainColor
        weeklyCalendar.appearance.titleTodayColor = .white
        weeklyCalendar.appearance.selectionColor = .subGreenColor
        weeklyCalendar.appearance.titleSelectionColor = .mainColor
        weeklyCalendar.appearance.eventDefaultColor = .mainColor
        
        weeklyCalendar.scrollEnabled = false
        
        output.bindCalendarAllEvent
            .subscribe(onNext: { [weak self] dates in
                guard let self = self else { return }
                self.eventDates = dates
                monthlyCalendar.monthlyCalendar.reloadData()
                weeklyCalendar.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension CalendarViewController {
    private func setLayout() {
        view.addSubviews([monthlyCalendarView, weeklyCalendarView, divider, emptyLabel, tableView])
        monthlyCalendarView.addSubviews([monthlyCalendar])
        weeklyCalendarView.addSubviews([weeklyCalendar])
        
        monthlyCalendarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(320)
        }
        monthlyCalendar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(360)
        }
        
        weeklyCalendarView.snp.makeConstraints { make in
            make.top.equalTo(monthlyCalendarView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(80)
        }
        weeklyCalendar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(350)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(weeklyCalendarView.snp.bottom)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(1)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setEmptyLayout() {
        self.view.willRemoveSubview(tableView)
        self.view.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setTableViewLayout() {
        self.view.willRemoveSubview(emptyLabel)
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        monthlyCalendar.snp.updateConstraints {
            $0.height.equalTo(320)
        }
        weeklyCalendar.snp.updateConstraints {
            $0.height.equalTo(80)
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        input.getCalendarAlarmSections.onNext(date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return eventDates.filter { Calendar.current.isDate($0, inSameDayAs: date) }.count
    }
}


