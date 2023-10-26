//
//  AlarmTimePickerViewController.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class AlarmTimePickerViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    var viewModel: AlarmViewModel
    
    private var selectedTime = 0
    
    private let picker = UIPickerView()
    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    private let hoursLabel = UILabel()
    private let minLabel = UILabel()
    
    private let cancelButton = UIButton()
    private let completeButton = UIButton()
    private lazy var ButtonStackView = UIStackView(arrangedSubviews: [cancelButton, completeButton])
    
    init(viewModel: AlarmViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setAutoLayout()
        setGesture()
    }
    
    private func setGesture() {
        cancelButton.rx.tap
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.customTime.accept(self.selectedTime)
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "사용자 설정"
        
        picker.delegate = self
        picker.dataSource = self
        picker.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        viewModel.customTime
            .subscribe { [weak self] min in
                if min != 0 {
                    self?.selectedTime = min
                    let hours = min / 60
                    let minutes = min % 60
                    self?.picker.selectRow(hours, inComponent: 1, animated: false)
                    self?.picker.selectRow(minutes, inComponent: 3, animated: false)
                }
            }
            .disposed(by: disposeBag)
        
        hoursLabel.setup(text: "시간", color: .gray80, size: 17, weight: .bold)
        minLabel.setup(text: "분 전", color: .gray80, size: 17, weight: .bold)
        
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.gray80, for: .normal)
        cancelButton.backgroundColor = .gray20
        cancelButton.layer.cornerRadius = 10
        
        completeButton.setTitle("완료", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = .mainColor
        completeButton.layer.cornerRadius = 10
        
        ButtonStackView.axis = .horizontal
        ButtonStackView.distribution = .fillEqually
        ButtonStackView.spacing = 24
    }
    
    private func setAutoLayout() {
        self.view.addSubviews([picker, ButtonStackView])
        picker.addSubviews([hoursLabel, minLabel])
        
        picker.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalTo(260)
        }
        
        hoursLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.leading.equalToSuperview().offset(80)
        }
        
        minLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.leading.equalToSuperview().offset(190)
        }
        
        ButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(picker.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(48)
        }
    }
}

extension AlarmTimePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            return hours.count
        } else if component == 3 {
            return minutes.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0, 5:
            return 0
        default:
            return 50
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       if component == 1 {
           return String(format: "%02d", hours[row])
       } else if component == 3 {
           return String(format: "%02d", minutes[row])
       } else {
           return ""
       }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = pickerView.selectedRow(inComponent: 1)
        let selectedMinute = pickerView.selectedRow(inComponent: 3)
        let min = selectedHour * 60 + selectedMinute
        
        self.selectedTime = min
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
