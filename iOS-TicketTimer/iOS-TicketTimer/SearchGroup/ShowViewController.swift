import UIKit

class ShowViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var interparkButton: UIButton!
    @IBOutlet weak var melonButton: UIButton!
    @IBOutlet weak var yes24Button: UIButton!
    
    var selectedButton: UIButton?
    
    let items: [Data] = Data.list
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = Data
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtonCorners(buttons: [interparkButton, melonButton, yes24Button])
        updateButtonColors(selectedButton: interparkButton)
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowCell", for: indexPath) as? ShowCell else {
                return nil
            }
            cell.configure(item)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot)
        
        collectionView.collectionViewLayout = layout()
        
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchTextField.backgroundColor = UIColor.clear
        
        let overlayButton = UIButton(frame: searchBar.bounds)  // UISearchBar 자체를 UIButton으로 인식하도록 함.
        searchBar.addSubview(overlayButton)
        overlayButton.addTarget(self, action: #selector(searchBarButtonTapped), for: .touchUpInside)
        
        self.title = "공연"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "공연"
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
    
    @objc func searchBarButtonTapped() {
        let searchController = UIStoryboard(name: "SearchStoryBoard", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        navigationController?.pushViewController(searchController, animated: true)
    }
    
    @IBAction func ticketingButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SearchStoryBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TicketingViewController") as! TicketingViewController
        present(vc, animated: true)
    }
    
    func setupButtonCorners(buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = 15 // 원하는 모서리 반지름 값 설정
        }
    }
    
    func updateButtonColors(selectedButton: UIButton) {
        let customGreenColor = UIColor(red: 10/255, green: 178/255, blue: 126/255, alpha: 1)
        
        // 이전 버튼 색상 복원
        self.selectedButton?.backgroundColor = .clear
        self.selectedButton?.setTitleColor(.lightGray, for: .normal)
        self.selectedButton?.layer.borderColor = UIColor.clear.cgColor

        // 선택된 버튼 색 변경
        selectedButton.backgroundColor = .clear
        selectedButton.setTitleColor(customGreenColor, for: .normal)
        selectedButton.layer.borderColor = customGreenColor.cgColor
        selectedButton.layer.borderWidth = 2

        // 선택된 버튼 저장
        self.selectedButton = selectedButton
    }

    @IBAction func interparkButtonTapped(_ sender: Any) {
        updateButtonColors(selectedButton: interparkButton)
        // 각각의 버튼이 눌렸을때 보여줘야할 화면을 구현
    }
    
    @IBAction func melonButtonTapped(_ sender: Any) {
        updateButtonColors(selectedButton: melonButton)
    }
    
    @IBAction func yes24ButtonTapped(_ sender: Any) {
        updateButtonColors(selectedButton: yes24Button)
    }
}

//extension ShowViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let framework = list[indexPath.item]
//    }
//}
