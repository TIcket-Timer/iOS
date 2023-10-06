//
//  ShowViewController.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import UIKit

class MusicalViewController: UIViewController {
    
    private let serachController = UISearchController()
    
    private let popularShowLabel = UILabel()
    private let selsectedPlatform: platform = .interpark
    
    private let searchView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        popularShowLabel.text = "인기공연 TOP 10"
        popularShowLabel.font = .systemFont(ofSize: 15, weight: .bold)
        
        
    }
}
