//
//  ShowViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit
import SnapKit
import RxSwift

class MusicalViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MusicalViewModel()
    
    private lazy var searchInactiveView = SearchInactiveView(viewModel: viewModel)
    private lazy var searchReadyView = SearchReadyView(viewModel: viewModel)
    private lazy var searchResultView = SearchResultView(viewModel: viewModel)
    private lazy var searchAllResultsView = SearchAllResultsView(viewModel: viewModel)
    
    private let searchController = UISearchController()
    
    private var isActiveSearch: Bool {
        return searchController.isActive
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateView(type: .inactive)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "검색"
    }

    private func setUI() {
        self.view.backgroundColor = .white

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색어를 입력하세요."
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .black
        searchController.searchBar.autocapitalizationType = .none
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchInactiveView.delegate = self
        searchReadyView.delegate = self
        searchResultView.delegate = self
        searchAllResultsView.delegate = self
    }
}

// MARK: - SearchController

extension MusicalViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            removeAllViews()
            updateView(type: .ready)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        removeAllViews()
        updateView(type: .result)

        guard let query = searchBar.text else { return }
        viewModel.addSearchHistory(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeAllViews()
        updateView(type: .inactive)
    }
    
    enum ViewType {
        case inactive, ready, result
    }
    
    private func removeAllViews() {
        searchInactiveView.removeFromSuperview()
        searchReadyView.removeFromSuperview()
        searchResultView.removeFromSuperview()
        searchAllResultsView.removeFromSuperview()
    }
    
    func updateView(type: ViewType) {
        let updatedView: UIView
        switch type {
        case .inactive:
            updatedView = searchInactiveView
        case .ready:
            updatedView = searchReadyView
        case .result:
            updatedView = searchResultView
        }

        self.view.addSubview(updatedView)
        updatedView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension MusicalViewController: SearchInactiveViewDelegate {
    func didTapCell(_: SearchInactiveView) {
        viewModel.showMusicalDetailViewController(viewController: self)
    }
}

extension MusicalViewController: SearchReadyViewDelegate {
    func didTapHistoryButton(_: SearchReadyView, history: String) {
        searchController.searchBar.text = history
        searchBarSearchButtonClicked(searchController.searchBar)
    }
    
    func didTapCell(_: SearchReadyView) {
        viewModel.showMusicalDetailViewController(viewController: self)
    }
}

extension MusicalViewController: SearchResultViewDelegate {
    func didTapCell(_ : SearchResultView) {
        viewModel.showMusicalDetailViewController(viewController: self)

    }
    
    func didTapAlarmSetting(_: SearchResultView, indexPath: IndexPath) {
        viewModel.presentAlarmSettingViewController(viewController: self, at: indexPath.row)
    }
    
    func didTapShowAllResults(resultType: ShowAllResultsType) {
        searchAllResultsView.type = resultType
        searchAllResultsView.resetFilter()
        
        self.view.addSubview(searchAllResultsView)
        searchAllResultsView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

extension MusicalViewController: SearchAllResultsViewDelegate {
    func didTapCell(_ : SearchAllResultsView) {
        viewModel.showMusicalDetailViewController(viewController: self)
    }
    
    func didTapAlarmSetting(_ : SearchAllResultsView, indexPath: IndexPath) {
        viewModel.presentAlarmSettingViewController(viewController: self, at: indexPath.row)
    }
}
