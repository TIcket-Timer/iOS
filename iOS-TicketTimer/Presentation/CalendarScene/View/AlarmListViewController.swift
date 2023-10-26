//
//  AlarmListViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import RxDataSources

class AlarmListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel = AlarmViewModel()
    private lazy var input = AlarmViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        input.getAlarmSections.onNext([])
    }
    
    private func setUI() {
        view.backgroundColor = .white
        navigationItem.title = "알람 내역"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
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
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource[index].header.toDateKor()
        }
        
        output.alarmSections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(Alarm.self)
        )
        .subscribe(onNext: { [weak self] indexPath, item in
            guard let self = self else { return }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            let vc = AlarmSettingViewController(notice: item.musicalNotice)
            vc.delegate = self
            let nav = BottomSheetNavigationController(rootViewController: vc, heigth: 650)
            self.present(nav, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
    
    private func setAutoLayout() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AlarmListViewController: AlarmSettingDelegate {
    func viewWillDisappear() {
        input.getAlarmSections.onNext([])
    }
}
