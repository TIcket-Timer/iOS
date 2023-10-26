//
//  AlarmViewModel.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/19.
//

import RxSwift
import RxRelay
import UserNotifications

class AlarmViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    private let alarmService = AlarmService.shared
    
    var alarmId: String?
    var notice: MusicalNotice?
    var savedLocalAlarms = [LocalAlarm]()

    var fiveMinSwitchIsOn = BehaviorRelay<Bool>(value: false)
    var tenMinSwitchIsOn = BehaviorRelay<Bool>(value: false)
    var twentyMinSwitchIsOn = BehaviorRelay<Bool>(value: false)
    var thirtyMinSwitchIsOn = BehaviorRelay<Bool>(value: false)
    var customTime = BehaviorRelay<Int>(value: 0)
    
    struct Input {
        var getAllAlarms = PublishSubject<[Alarm]>()
        var getAlarmSections = PublishSubject<[Alarm]>()
        var getNoticeAlarms = PublishSubject<MusicalNotice>()
        var upateNotcieAlarms = PublishSubject<[Int]>()
        var postNoticeAlarms = PublishSubject<[Int]>()
    }
    struct Output {
        var alarms = PublishRelay<[Alarm]>()
        var alarmSections = PublishRelay<[AlarmSection]>()
        var localAlarms = PublishRelay<[LocalAlarm]>()
    }
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.getAllAlarms
            .flatMap { _ in
                return self.alarmService.getAllAlarms()
            }
            .subscribe(onNext: { alarms in
                let section = AlarmSection(items: alarms, header: "")
                output.alarmSections.accept([section])
            })
            .disposed(by: disposeBag)
        
        input.getAlarmSections
            .flatMap { _ in
                return self.alarmService.getAllAlarms()
            }
            .subscribe(onNext: { alarms in
                var sections: [AlarmSection] = []
                var groupedAlarms = [String: [Alarm]]()

                let sortedAlarms = alarms.sorted {
                    $0.musicalNotice.openDateTime ?? "" < $1.musicalNotice.openDateTime ?? ""
                }
                sortedAlarms.forEach { alarm in
                    let header = String(alarm.musicalNotice.openDateTime?.prefix(8) ?? "")
                    if groupedAlarms[header] == nil {
                        groupedAlarms[header] = [alarm]
                    } else {
                        groupedAlarms[header]?.append(alarm)
                    }
                }

                for (header, alarms) in groupedAlarms {
                    let section = AlarmSection(items: alarms, header: header)
                    sections.append(section)
                }
                
                output.alarmSections.accept(sections)
            })
            .disposed(by: disposeBag)

        input.getNoticeAlarms
            .observe(on: MainScheduler.instance)
            .flatMap { notice -> Observable<[LocalAlarm]> in
                return self.alarmService.getLocalAlarms(notice: notice)
            }
            .subscribe{ [weak self] alarms in
                output.localAlarms.accept(alarms)
                
                self?.savedLocalAlarms = alarms
                if !alarms.isEmpty {
                    self?.alarmId = alarms[0].alarmId
                }
            }
            .disposed(by: disposeBag)
        
        input.postNoticeAlarms
            .observe(on: backgroundScheduler)
            .subscribe { [weak self] times in
                guard let notice = self?.notice else { return }
                self?.alarmService.postNoticeAlarms(notice: notice, alarmTimes: times)
            }
            .disposed(by: disposeBag)
        
        input.upateNotcieAlarms
            .observe(on: backgroundScheduler)
            .subscribe { [weak self] newTimes in
                guard let self = self else { return }
                guard let notice = self.notice else { return }
                self.alarmService.updateNoticeAlarms(savedLocalAlarms: self.savedLocalAlarms, notice: notice, newAlarmTimes: newTimes)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
