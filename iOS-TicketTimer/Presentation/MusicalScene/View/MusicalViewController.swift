//
//  ShowViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit
import SnapKit

class MusicalViewController: UIViewController {
    
    private let viewModel = MusicalViewModel()
    private lazy var searchInactiveView = SearchInactiveView(viewModel: viewModel)
    private lazy var searchReadyView = SearchReadyView()
    private lazy var searchResultView = SearchResultView()
    
    private let searchController = UISearchController()

    
    
    private var searchQuery = ""
    
    private var isActiveSearch: Bool {
        return searchController.isActive
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
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
    }

    private func setAutoLayout() {
        self.view.addSubview(searchInactiveView)

        searchInactiveView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - SearchController

extension MusicalViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        self.searchQuery = text

        if isActiveSearch {
            updateSearchReadyView()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResultView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        deleteSearchView()
    }
    
    func updateSearchReadyView() {
        self.view.addSubview(searchReadyView)
        
        searchReadyView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func updateSearchResultView() {
        self.view.addSubview(searchResultView)
        
        searchResultView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func deleteSearchView() {
        searchReadyView.removeFromSuperview()
        searchResultView.removeFromSuperview()
    }
}

extension MusicalViewController: SearchInactiveViewDelegate {
    func didTapCell(_: SearchInactiveView, indexPath: IndexPath) {
        let vc = MusicalDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MusicalViewController: SearchReadyViewDelegate {
    func didTapCell(_: SearchReadyView, indexPath: IndexPath) {
        let vc = MusicalDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MusicalViewController: SearchResultViewDelegate {
    func didTapCell(_: SearchResultView, indexPath: IndexPath) {
        let vc = MusicalDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAlarmSetting() {
        let vc = AlarmSettingViewController(platform: .interpark)
        vc.navigationItem.title = "알람 설정"
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .automatic
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
        }
        
        self.present(navigationController, animated: true, completion: nil)
    }
}
