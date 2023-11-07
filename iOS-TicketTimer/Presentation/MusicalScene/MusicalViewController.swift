//
//  ShowViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit
import SnapKit
import RxSwift
import RxSwift

enum SearchState {
    case topMusicals
    case searchReady
    case searchResults
}

class MusicalViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MusicalViewModel()
    private lazy var input = MusicalViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private lazy var topMusicalsVC = TopMusicalsViewController(viewModel: viewModel)
    private lazy var searchReadyVC = SearchReadyViewController(viewModel: viewModel)
    private lazy var searchResultsVC = SearchResultsViewController(viewModel: viewModel)
    
    private let searchController = UISearchController()
    
    private var isReadySearch: Bool {
        return searchController.isActive
        && searchController.searchBar.text?.isEmpty == true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        add(asChildViewController: topMusicalsVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "검색"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
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
        
        searchReadyVC.delegate = self
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView(for searchState: SearchState) {
        switch searchState {
        case .topMusicals:
            remove(asChildViewController: searchReadyVC)
            remove(asChildViewController: searchResultsVC)
            add(asChildViewController: topMusicalsVC)
        case .searchReady:
            remove(asChildViewController: topMusicalsVC)
            remove(asChildViewController: searchResultsVC)
            add(asChildViewController: searchReadyVC)
        case .searchResults:
            remove(asChildViewController: topMusicalsVC)
            remove(asChildViewController: searchReadyVC)
            add(asChildViewController: searchResultsVC)
        }
    }
}

// MARK: - SearchController

extension MusicalViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if isReadySearch {
            updateView(for: .searchReady)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        viewModel.query = query
        
        updateView(for: .searchResults)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateView(for: .topMusicals)
    }
}

extension MusicalViewController: SearchReadyViewControllerDelegate {
    func didTapHistoryButton(_: SearchReadyViewController, history: String) {
        searchController.searchBar.text = history
        searchBarSearchButtonClicked(searchController.searchBar)
    }
}
