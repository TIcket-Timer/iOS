//
//  HomeViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import SnapKit
import FSCalendar

class HomeViewController: UIViewController {
	
	// 상단 노치 값 구하기
	let scenes = UIApplication.shared.connectedScenes
	lazy var windowScene = self.scenes.first as? UIWindowScene
	lazy var topSafeAreaInsets: CGFloat = self.windowScene?.windows.first?.safeAreaInsets.top ?? 0.0
    
	// UI
	private let scrollView = UIScrollView()
	private let contentView = UIView()
	private lazy var topBgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 86 + self.topSafeAreaInsets))
    private let logoImageView = UIImageView()
    private let calendarView = UIView()
    private lazy var calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 48, height: self.view.frame.width - 46))
	private let markIconImageView = UIImageView()
	private let ticketLabel = UILabel()
	private let tableView = UITableView()
	private let shadowView = UIView()
	private let showOpenLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
	
	// datasource
	private let tableViewData: [String] = ["뮤지컬1", "뮤지컬2", "뮤지컬3", "뮤지컬4"]
    private let collectionViewData: [String] = ["opera", "hest", "farinelli", "opera", "hest", "farinelli", "opera", "hest", "farinelli"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: false)
	}
    
    private func setUI() {
        self.view.backgroundColor = .white
		
		self.view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		contentView.addSubviews([shadowView, showOpenLabel, collectionView])
		shadowView.addSubviews([topBgView, calendarView, markIconImageView, ticketLabel, tableView])
        topBgView.addSubview(logoImageView)
        calendarView.addSubview(calendar)
		
		shadowView.backgroundColor = .white
		shadowView.layer.cornerRadius = 16
		shadowView.layer.masksToBounds = false
		shadowView.layer.shadowColor = UIColor.black.cgColor
		shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
		shadowView.layer.shadowOpacity = 0.2
		shadowView.layer.shadowRadius = 16.0
    
        let gradient = CAGradientLayer()
        gradient.frame = topBgView.bounds
        gradient.colors = [UIColor("#00D090").cgColor, UIColor("#0AB27E").cgColor]
        topBgView.layer.insertSublayer(gradient, at: 0)
        topBgView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        logoImageView.image = UIImage(named: "homeLogo")
        
        calendarView.backgroundColor = .white
        calendarView.layer.cornerRadius = 10
        calendarView.layer.masksToBounds = false
        calendarView.layer.shadowColor = UIColor.black.cgColor
        calendarView.layer.shadowOffset = CGSize(width: 0, height: 4)
        calendarView.layer.shadowOpacity = 0.2
        calendarView.layer.shadowRadius = 10.0
        
        calendar.dataSource = self
        calendar.delegate = self
		
		markIconImageView.image = UIImage(named: "markIcon")
        
		ticketLabel.text = "예매 임박"
		ticketLabel.font = .systemFont(ofSize: 17, weight: .bold)
		ticketLabel.textColor = .mainColor
		
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
		tableView.rowHeight = 42
		
		showOpenLabel.text = "공연 오픈 소식"
        showOpenLabel.font = .systemFont(ofSize: 17, weight: .bold)
        showOpenLabel.textColor = .gray100
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 125, height: 165)
        flowLayout.minimumLineSpacing = 12
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setAutoLayout() {
		scrollView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
		
		contentView.snp.makeConstraints {
			$0.width.equalToSuperview()
			$0.centerX.bottom.equalToSuperview()
			$0.top.equalToSuperview().offset(-self.topSafeAreaInsets) // 노치 높이만큼 위로 올리기
		}
		
		shadowView.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview()
			$0.bottom.equalTo(tableView.snp.bottom).offset(30)
		}
		
        topBgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        logoImageView.snp.makeConstraints {
			$0.centerY.equalToSuperview().offset(8)
			$0.centerX.equalToSuperview()
            $0.width.height.equalTo(35)
        }
        
        calendarView.snp.makeConstraints {
			$0.top.equalTo(topBgView.snp.bottom).offset(-27)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.width.height.equalTo(self.view.frame.width - 48)
        }
		
		markIconImageView.snp.makeConstraints {
			$0.leading.equalToSuperview().offset(24)
			$0.top.equalTo(calendarView.snp.bottom).offset(24)
			$0.width.height.equalTo(20)
		}
		
		ticketLabel.snp.makeConstraints {
			$0.leading.equalTo(markIconImageView.snp.trailing).offset(5)
			$0.top.equalTo(calendarView.snp.bottom).offset(24)
		}
		
		tableView.snp.makeConstraints {
			$0.top.equalTo(ticketLabel.snp.bottom)
			$0.leading.equalToSuperview().offset(24)
			$0.trailing.equalToSuperview().offset(-24)
			$0.height.equalTo(42 * tableViewData.count)
		}
		
		showOpenLabel.snp.makeConstraints {
			$0.top.equalTo(shadowView.snp.bottom).offset(40)
			$0.leading.equalToSuperview().offset(24)
		}
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(showOpenLabel.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(180)
            $0.bottom.equalToSuperview().offset(-24)
        }
    }
}

// MARK: - 캘린더
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        
        self.view.layoutIfNeeded()
    }
}

// MARK: - 테이블뷰
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return tableViewData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
		
		cell.label.text = tableViewData[indexPath.row]
		
		return cell
	}
}

// MARK: - 콜렉션뷰
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: collectionViewData[indexPath.row])
        
        return cell
    }
}
