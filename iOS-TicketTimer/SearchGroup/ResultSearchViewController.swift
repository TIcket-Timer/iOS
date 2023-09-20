
import UIKit

class ResultSearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var groupCount: UILabel!
    
    var filteredData: [Data] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = Data
    enum Section {
        case main
    }
    
    var searchString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultSearchCell", for: indexPath) as? ResultSearchCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredData, toSection: .main)
        dataSource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        
        groupCount.text = "검색결과 \(filteredData.count)건"
        
        searchBar.placeholder = "\(searchString!)"
        searchBar.searchTextField.backgroundColor = UIColor.clear
        searchBar.isUserInteractionEnabled = false
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "검색"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "검색"
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        // item -> group -> section -> layout
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(193))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(193))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    @IBAction func ticketingButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TicketingViewController") as! TicketingViewController
        present(vc, animated: true)
    }
}
