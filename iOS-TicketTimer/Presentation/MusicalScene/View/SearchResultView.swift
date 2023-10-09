//
//  SearchResultView.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/07.
//

import UIKit

class SearchResultView: UIView {
    
    private let emptyLabel = UILabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let numberOfResult = 0
    private let researchResultLable = UILabel()
    
    private let filterButton = UIButton()
    private let filterView = FilterView()
    
    private let tableView = UITableView()
    
    private var selectedPlatforms: [Platform] = Platform.allCases
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .white
        
        emptyLabel.text = "검색 결과가 있습니다."
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.showsVerticalScrollIndicator = false
        
        researchResultLable.text = "검색결과 \(numberOfResult)건"
        researchResultLable.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        filterButton.setTitle("전체", for: .normal)
        filterButton.setTitleColor(.black, for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
        let image = UIImage(systemName: "chevron.up", withConfiguration: imageConfig)
        filterButton.setImage(image, for: .normal)
        filterButton.tintColor = .black
        filterButton.semanticContentAttribute = .forceRightToLeft
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        filterView.isHidden = true
        filterView.filterAction = { [weak self] platforms in
            self?.selectedPlatforms = platforms
            self?.filterView.isHidden = true
            self?.toggleFilterButtonArrow()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MusicalPopularTableViewCell.self,
                                  forCellReuseIdentifier: MusicalPopularTableViewCell.identifier)
        tableView.rowHeight = 184
    }
    
    private func setAutoLayout() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([emptyLabel, researchResultLable, filterButton, tableView])
        contentView.addSubview(filterView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        researchResultLable.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        filterButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        filterView.snp.makeConstraints { make in
            make.top.equalTo(filterButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(researchResultLable.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(184 * 5)
        }
    }
    
    @objc func filterButtonTapped() {
        filterView.isHidden.toggle()
        toggleFilterButtonArrow()
    }
    
    private func toggleFilterButtonArrow() {
        if filterView.isHidden {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
            let image = UIImage(systemName: "chevron.up", withConfiguration: imageConfig)
            filterButton.setImage(image, for: .normal)
        } else {
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .light)
            let image = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
            filterButton.setImage(image, for: .normal)
        }
    }
}

extension SearchResultView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MusicalPopularTableViewCell.identifier, for: indexPath) as! MusicalPopularTableViewCell

        cell.musicalImageView.image = UIImage(named: "opera")

        return cell
    }
}

class FilterView: UIView {

    private let allLabel = UILabel()
    private let allSpacer = UIView()
    private let allArrow = UIImageView()
    private let allButton = UIButton()
    
    private let interparkLabel = UILabel()
    private let interparkSpacer = UIView()
    private let interparkArrow = UIImageView()
    private let interparkButton = UIButton()

    private let melonLabel = UILabel()
    private let melonSpacer = UIView()
    private let melonArrow = UIImageView()
    private let melonButton = UIButton()

    private let yes24Label = UILabel()
    private let yes24Spacer = UIView()
    private let yes24Arrow = UIImageView()
    private let yes24Button = UIButton()
    
    private lazy var allStackView = UIStackView(arrangedSubviews: [allLabel, allSpacer, allArrow])
    private lazy var interparkStackView = UIStackView(arrangedSubviews: [interparkLabel, interparkSpacer, interparkArrow])
    private lazy var melonStackView = UIStackView(arrangedSubviews: [melonLabel, melonSpacer, melonArrow])
    private lazy var yes24StackView = UIStackView(arrangedSubviews: [yes24Label, yes24Spacer, yes24Arrow])
    
    var filterAction: (([Platform]) -> Void)?
    
    let divider = UIView()
    
    override init(frame: CGRect) {
        self.filterAction = nil
        super.init(frame: frame)
        setUI()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        allLabel.text = "전체"
        allLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        allArrow.image = UIImage(systemName: "chevron.right")
        allArrow.tintColor = .gray60
        allButton.backgroundColor = .clear
        allButton.addTarget(self, action: #selector(FilterTapped), for: .touchUpInside)
        
        interparkLabel.text = "인터파크티켓"
        interparkLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        interparkArrow.image = UIImage(systemName: "chevron.right")
        interparkArrow.tintColor = .gray60
        interparkButton.backgroundColor = .clear
        interparkButton.addTarget(self, action: #selector(FilterTapped), for: .touchUpInside)
        
        melonLabel.text = "멜론티켓"
        melonLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        melonArrow.image = UIImage(systemName: "chevron.right")
        melonArrow.tintColor = .gray60
        melonButton.backgroundColor = .clear
        melonButton.addTarget(self, action: #selector(FilterTapped), for: .touchUpInside)
        
        yes24Label.text = "yes24"
        yes24Label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        yes24Arrow.image = UIImage(systemName: "chevron.right")
        yes24Arrow.tintColor = .gray60
        yes24Button.backgroundColor = .clear
        yes24Button.addTarget(self, action: #selector(FilterTapped), for: .touchUpInside)
        
        allStackView.axis = .horizontal
        interparkStackView.axis = .horizontal
        melonStackView.axis = .horizontal
        yes24StackView.axis = .horizontal
        
        divider.backgroundColor = UIColor("#E8E8E8")
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.12
    }
    
    private func setAutoLayout() {
        self.addSubviews([allStackView, interparkStackView, melonStackView, yes24StackView, divider])
        allStackView.addSubview(allButton)
        interparkStackView.addSubview(interparkButton)
        melonStackView.addSubview(melonButton)
        yes24StackView.addSubview(yes24Button)
        
        allStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        allButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        interparkStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        interparkButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        melonStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        melonButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        yes24StackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.trailing.equalToSuperview().offset(-30)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        yes24Button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        divider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(1)
        }
    }
    
    @objc func FilterTapped(_ sender: UIButton) {
        if sender == allButton {
            filterAction?(Platform.allCases)
        } else if sender == interparkButton {
            filterAction?([.interpark])
        } else if sender == melonButton {
            filterAction?([.melon])
        } else if sender == yes24Button {
            filterAction?([.yes24])
        }
    }
}