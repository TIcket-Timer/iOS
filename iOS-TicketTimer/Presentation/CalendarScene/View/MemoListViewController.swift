//
//  MemoListViewController.swift
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

class MemoListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel = CalendarViewModel()
    private lazy var input = viewModel.input
    private lazy var output = viewModel.output
    
    private let emptyLabel = UILabel()
    
    private let tableView = UITableView()
    
    private let addMemoButton = UIImageView(image: UIImage(named: "addmemo"))
    
    private var sections = [MemoSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setEmptyLayout()
        
        input.getMemoSections.onNext(())
    }

    override func viewDidAppear(_ animated: Bool) {
        input.getMemoSections.onNext(())
    }
    
    private func setUI() {
        view.backgroundColor = .white
        navigationItem.title = "메모 목록"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        emptyLabel.setup(text: "등록된 메모가 없습니다.", color: .gray100, size: 17, weight: .medium)
        
        tableView.register(
            MemoListTableViewCell.self,
            forCellReuseIdentifier: MemoListTableViewCell.identifier
        )
        tableView.backgroundColor = .gray10
        tableView.separatorStyle = .none
        
        let dataSource = RxTableViewSectionedReloadDataSource<MemoSection> {
            dataSource, tableView, indexPath, item  in
            let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as! MemoListTableViewCell
            cell.cellData.onNext(item)
            cell.selectionStyle = .none
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource[index].header.toDateMemoKor()
        }
        
        output.bindMemoSections
            .do(onNext: { [weak self] sections in
                if sections.isEmpty {
                    self?.setEmptyLayout()
                } else {
                    self?.setTableViewLayout()
                }
                
                self?.sections = sections
                self?.tableView.reloadData()
            })
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(Memo.self)
        )
        .subscribe(onNext: { [weak self] indexPath, item in
            guard let self = self else { return }
            
            self.tableView.deselectRow(at: indexPath, animated: true)
            let vc = AddMemoViewController(viewModel: viewModel, id: item.id)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
                
                tableView.rx.itemDeleted
                .subscribe { [weak self] indexPath in
                    guard let section = self?.sections[indexPath.section] else { return }
                    let memo = section.items[indexPath.row]
                    self?.input.deleteMemo.onNext(memo.id ?? 0)
                }
                .disposed(by: disposeBag)

                
        addMemoButton.rx.tapGesture()
                .when(.recognized)
                .subscribe { [weak self] _ in
                    let vc = AddMemoViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.navigationController?.present(vc, animated: true)
                }
                .disposed(by: disposeBag)
    }
}

extension MemoListViewController {
    private func setEmptyLayout() {
        self.view.willRemoveSubview(tableView)
        self.view.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        setAddButtonLayout()
    }
    
    private func setTableViewLayout() {
        self.view.willRemoveSubview(emptyLabel)
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setAddButtonLayout()
    }
    
    private func setAddButtonLayout() {
        view.addSubview(addMemoButton)
        addMemoButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.width.equalTo(44)
        }
    }
}

