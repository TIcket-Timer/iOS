//
//  ShowViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit
import SnapKit

class MusicalViewController: UIViewController {
    
    private let searchController = UISearchController()

    private let searchInactiveView = SearchInactiveView()
    private let searchReadyView = SearchReadyView()
    private let searchResultView = SearchResultView()
    
    private var searchQuery = ""
    
    private var isActiveSearch: Bool {
        return searchController.isActive
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
    }

    private func setUI() {
        navigationItem.title = "검색"
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
        
        searchInactiveView.delegate = self
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
        let VC = MusicalDetailViewController()
        navigationController?.pushViewController(VC, animated: true)
    }
}
