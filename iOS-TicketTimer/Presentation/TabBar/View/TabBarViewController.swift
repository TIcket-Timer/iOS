//
//  TabBarViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import RxSwift
import RxCocoa
import RxGesture
import SnapKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
	
	private let disposeBag = DisposeBag()
	private var viewModel = TabBarViewModel()
	private lazy var input = TabBarViewModel.Input()
	private lazy var output = viewModel.transform(input: input)
	
	private var tabBarItems: [Tab: UITabBarItem] {
		let home = UITabBarItem(title: "홈", image: UIImage(named: "house"), selectedImage: UIImage(named: "houseFill"))
		let show = UITabBarItem(title: "공연", image: UIImage(named: "ticket"), selectedImage: UIImage(named: "ticketFill"))
		let calendar = UITabBarItem(title: "캘린더", image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendarFill"))
		let settings = UITabBarItem(title: "설정", image: UIImage(named: "gear"), selectedImage: UIImage(named: "gearFill"))
		
		return [
			.Home: home,
			.Show: show,
			.Calendar: calendar,
			.Settings: settings
		]
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setTabBar()
		self.navigationController?.isNavigationBarHidden = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.setNavigationBarHidden(true, animated: false)
        print("viewwillappear")
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    	
	// MARK: - 탭바 세팅
	private func setTabBar() {
		self.delegate = self
		tabBar.backgroundColor = .white
		tabBar.tintColor = .mainColor
		tabBar.layer.borderColor = UIColor.gray40.cgColor
		tabBar.layer.borderWidth = 1
		tabBar.unselectedItemTintColor = .gray60
		
		let homeTab = UINavigationController(rootViewController: HomeViewController())
		let showTab = UINavigationController(rootViewController: MusicalViewController())
		let calendarTab = UINavigationController(rootViewController: AlarmListViewController())
		let settingsTab = UINavigationController(rootViewController: SettingsViewController())
		
		homeTab.tabBarItem = tabBarItems[.Home]
		showTab.tabBarItem = tabBarItems[.Show]
		calendarTab.tabBarItem = tabBarItems[.Calendar]
		settingsTab.tabBarItem = tabBarItems[.Settings]
		
		self.viewControllers = [homeTab, showTab, calendarTab, settingsTab]
	}
}
