//
//  AlarmViewModel.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/19.
//

import RxRelay
import UserNotifications

class AlarmViewModel {
    
    private var notice: MusicalNotice
    private var savedLocalAlarms = [LocalAlarm]()
    private let userDefaultService = UserDefaultService.shared

    var fiveMinSwitchIsOn = BehaviorRelay<Bool>(value: false)
    var tenMinSwitchIsOn = BehaviorRelay<Bool>(value: false)
    var twentyMinSwitchIsOn = BehaviorRelay<Bool>(value: false)
    var thirtyMinSwitchIsOn = BehaviorRelay<Bool>(value: false)
    
    init(notice: MusicalNotice) {
        self.notice = notice
        self.savedLocalAlarms = userDefaultService.getLocalAlarmData(notice: notice)
        bindSwitches()
    }
    
    func bindSwitches() {
        fiveMinSwitchIsOn.accept(savedLocalAlarms.contains { $0.type == .five })
        tenMinSwitchIsOn.accept(savedLocalAlarms.contains { $0.type == .ten })
        twentyMinSwitchIsOn.accept(savedLocalAlarms.contains { $0.type == .twenty })
        thirtyMinSwitchIsOn.accept(savedLocalAlarms.contains { $0.type == .thirty })
    }
    
    func completeButtonAction() {
        // 기존 알림 삭제
        cancelNotification(alarms: savedLocalAlarms)
        userDefaultService.deleteLocalAlarmData(alarms: savedLocalAlarms)
        
        // 새로운 알림으로 업데이트
        guard
            let id = notice.id,
            let title = notice.title
            //let date = notice.openDateTime?.toDateType()
        else { return }
        let date = Date()
        
        if fiveMinSwitchIsOn.value { updateLocalAlarm(type: .five, id: id, title: title, date: date) }
        if tenMinSwitchIsOn.value { updateLocalAlarm(type: .ten, id: id, title: title, date: date) }
        if twentyMinSwitchIsOn.value { updateLocalAlarm(type: .twenty, id: id, title: title, date: date) }
        if thirtyMinSwitchIsOn.value { updateLocalAlarm(type: .thirty, id: id, title: title, date: date) }
    }

    func updateLocalAlarm(type: LocalAlarmType, id: String, title: String, date: Date) {
        let alarm = LocalAlarm(noticeId: id, noticeTitle: title, noticeOpenDate: date, type: type)
        sendNotification(alarm: alarm)
        userDefaultService.saveLocalAlarmData(alarms: alarm)
    }
    
    func sendNotification(alarm: LocalAlarm) {
        let content = UNMutableNotificationContent()
        content.title = alarm.title
        content.body = alarm.body
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: alarm.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let identifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func cancelNotification(alarms: [LocalAlarm]) {
        let identifiers = alarms.map { $0.id }
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
