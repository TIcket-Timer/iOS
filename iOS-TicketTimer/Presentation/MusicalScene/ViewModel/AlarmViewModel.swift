//
//  AlarmViewModel.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/19.
//

import Foundation
import UserNotifications

class AlarmViewModel {
    
    private var notice: MusicalNotice
    private var savedLocalAlarms = [LocalAlarm]()
    private let userDefaultService = UserDefaultService.shared

    var fiveMinSwitchIsOn: Bool = false
    var tenMinSwitchIsOn: Bool = false
    var twentyMinSwitchIsOn: Bool = false
    var thirtyMinSwitchIsOn: Bool = false
    
    init(notice: MusicalNotice) {
        self.notice = notice
        self.savedLocalAlarms = userDefaultService.getLocalAlarmData(notice: notice)
        bindSwitch()
    }
    
    func bindSwitch() {
        if savedLocalAlarms.contains(where: { $0.type == .five }) {
            fiveMinSwitchIsOn = true
        }
        
        if savedLocalAlarms.contains(where: { $0.type == .ten }) {
            tenMinSwitchIsOn = true
        }
        
        if savedLocalAlarms.contains(where: { $0.type == .twenty }) {
            twentyMinSwitchIsOn = true
        }
        
        if savedLocalAlarms.contains(where: { $0.type == .thirty }) {
            thirtyMinSwitchIsOn = true
        }
    }
    
    func completeButtonAction() {
        // 기존 알림 삭제
        cancelNotification(alarmData: savedLocalAlarms)
        userDefaultService.deleteLocalAlarmData(alarms: savedLocalAlarms)
        
        
        // 새로운 알림으로 업데이트
        guard
            let id = notice.id,
            let title = notice.title
            //let date = notice.openDateTime?.toDateType()
        else { return }
        let date = Date()
        
        if fiveMinSwitchIsOn {
            let alarm = LocalAlarm(noticeId: id, noticeTitle: title, noticeOpenDate: date, type: .five)
            sendNotification(alarmData: alarm)
            userDefaultService.saveLocalAlarmData(alarms: alarm)
        }
        
        if tenMinSwitchIsOn {
            let alarm = LocalAlarm(noticeId: id, noticeTitle: title, noticeOpenDate: date, type: .ten)
            sendNotification(alarmData: alarm)
            userDefaultService.saveLocalAlarmData(alarms: alarm)
        }
        
        if twentyMinSwitchIsOn {
            let alarm = LocalAlarm(noticeId: id, noticeTitle: title, noticeOpenDate: date, type: .twenty)
            sendNotification(alarmData: alarm)
            userDefaultService.saveLocalAlarmData(alarms: alarm)
        }
        
        if thirtyMinSwitchIsOn {
            let alarm = LocalAlarm(noticeId: id, noticeTitle: title, noticeOpenDate: date, type: .thirty)
            sendNotification(alarmData: alarm)
            userDefaultService.saveLocalAlarmData(alarms: alarm)
        }
    }
    
    func sendNotification(alarmData: LocalAlarm) {
        let content = UNMutableNotificationContent()
        content.title = alarmData.title
        content.body = alarmData.body
        content.sound = UNNotificationSound.default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: alarmData.date)
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
    
    func cancelNotification(alarmData: [LocalAlarm]) {
        let identifiers = alarmData.map { $0.id }
        
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
