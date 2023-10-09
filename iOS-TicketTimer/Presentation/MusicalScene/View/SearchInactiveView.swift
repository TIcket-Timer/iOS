//
//  SearchInactiveView.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/09.
//

import UIKit
import SnapKit

protocol SearchInactiveViewDelegate: AnyObject {
    func didTapCell(_: SearchInactiveView, indexPath: IndexPath)
}

class SearchInactiveView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let popularMusicalLabel = UILabel()
    
    private var selectedPlatform: Platform = .interpark
    private let platformButtonContainer = UIView()
    private let interparkButton = UIButton()
    private let melonButton = UIButton()
    private let yes24Button = UIButton()
    
    private let popularTableView = UITableView()
    
    weak var delegate: SearchInactiveViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setAutoLayout()
        selectPlatformButton(interparkButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false

        popularMusicalLabel.text = "인기공연 TOP 10"
        popularMusicalLabel.font = .systemFont(ofSize: 15, weight: .bold)

        platformButtonContainer.backgroundColor = .gray40
        platformButtonContainer.layer.cornerRadius = 16
        
        interparkButton.setTitle("인터파크", for: .normal)
        interparkButton.setTitleColor(.gray60, for: .normal)
        interparkButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        interparkButton.addTarget(self, action: #selector(selectPlatformButton(_:)), for: .touchUpInside)

        melonButton.setTitle("멜론", for: .normal)
        melonButton.setTitleColor(.gray60, for: .normal)
        melonButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        melonButton.addTarget(self, action: #selector(selectPlatformButton(_:)), for: .touchUpInside)
        
        yes24Button.setTitle("yes24", for: .normal)
        yes24Button.setTitleColor(.gray60, for: .normal)
        yes24Button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        yes24Button.addTarget(self, action: #selector(selectPlatformButton(_:)), for: .touchUpInside)
        
        popularTableView.delegate = self
        popularTableView.dataSource = self
        popularTableView.register(MusicalPopularTableViewCell.self,
                                  forCellReuseIdentifier: MusicalPopularTableViewCell.identifier)
        popularTableView.rowHeight = 184
    }

    private func setAutoLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([popularMusicalLabel, platformButtonContainer, popularTableView])
        platformButtonContainer.addSubviews([interparkButton, melonButton, yes24Button])

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        popularMusicalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(24)
        }

        platformButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(popularMusicalLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(76)
            make.width.equalTo(240)
            make.height.equalTo(32)
        }

        interparkButton.snp.makeConstraints { make in
            make.width.equalTo(240 / 3)
            make.height.equalToSuperview()
            make.top.leading.equalToSuperview()
        }

        melonButton.snp.makeConstraints { make in
            make.width.equalTo(240 / 3)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalTo(interparkButton.snp.trailing)
        }

        yes24Button.snp.makeConstraints { make in
            make.width.equalTo(240 / 3)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.leading.equalTo(melonButton.snp.trailing)
        }

        popularTableView.snp.makeConstraints { make in
            make.top.equalTo(platformButtonContainer.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(184 * 10)
        }
    }
    
    @objc private func selectPlatformButton(_ sender: UIButton) {
        if sender == interparkButton {
            selectedPlatform = .interpark
        } else if sender == melonButton {
            selectedPlatform = .melon
        } else if sender == yes24Button {
            selectedPlatform = .yes24
        }
        
        UIView.animate(withDuration: 0.3) {
            self.interparkButton.setTitleColor(.gray60, for: .normal)
            self.interparkButton.layer.borderColor = UIColor.clear.cgColor
            self.interparkButton.backgroundColor = .clear
            self.melonButton.setTitleColor(.gray60, for: .normal)
            self.melonButton.layer.borderColor = UIColor.clear.cgColor
            self.melonButton.backgroundColor = .clear
            self.yes24Button.setTitleColor(.gray60, for: .normal)
            self.yes24Button.layer.borderColor = UIColor.clear.cgColor
            self.yes24Button.backgroundColor = .clear
            
            sender.setTitleColor(UIColor.mainColor, for: .normal)
            sender.layer.borderColor = UIColor.mainColor.cgColor
            sender.layer.borderWidth = 1.0
            sender.layer.cornerRadius = 16
            sender.backgroundColor = .white
        }
    }
}

// MARK: - popularTableView

extension SearchInactiveView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicalPopularTableViewCell.identifier, for: indexPath) as! MusicalPopularTableViewCell

        cell.musicalImageView.image = UIImage(named: "opera")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapCell(self, indexPath: indexPath)
    }
}