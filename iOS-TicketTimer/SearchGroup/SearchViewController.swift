//
//  SearchViewController.swift
//  iOS-TicketTimer
//
//  Created by Jinhyung Park on 2023/08/09.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let items: [Data] = Data.list
    var recentSearch: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchTextField.backgroundColor = UIColor.clear
        setupSearchBar()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "검색"
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "검색"
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchBar.resignFirstResponder()

        let filteredData = items.filter { item in
            item.title.lowercased().contains(searchText.lowercased())
        }
        
        addRecentSearch(searchText)
        
        let searchString = searchText
        let resultViewController = UIStoryboard(name: "SearchStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "ResultSearchViewController") as! ResultSearchViewController
        resultViewController.filteredData = filteredData
        resultViewController.searchString = searchString
        navigationController?.pushViewController(resultViewController, animated: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSearchCell", for: indexPath) as! RecentSearchCell
        cell.recentLabel.text = recentSearch[indexPath.item]
        return cell
    }
    
    func addRecentSearch(_ label: String) {
        recentSearch.insert(label, at: 0)
        collectionView.reloadData()
    }

}

