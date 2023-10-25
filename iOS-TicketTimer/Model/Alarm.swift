//
//  Alarm.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/19.
//

import Foundation

struct PushAlarm: Codable {
    let id: String
}

struct PushAlarmSetting: Codable {
    let interAlarm: Bool
    let melonAlarm: Bool
    let yesAlarm: Bool
}

struct PushAlarmSettingResult: Codable {
    let site: String
    let bool: Bool
}

struct Alarm: Codable {
    let id: Int
    let musicalNotice: MusicalNotice
    let alarmTimes: [Int]
}

struct AlarmResult: Codable {
    let id: String
    let createdTime, modifiedDate, openDateTime, title, url, siteCategory: String
}

struct LocalAlarm: Codable {
    var id: String = UUID().uuidString
    var alarmId: String
    var noticeId: String
    var title: String
    var body: String
    var date: Date
    var beforeMin: Int
    
    init(alarmId: String, notice: MusicalNotice, beforeMin: Int) {
        self.alarmId = alarmId
        self.noticeId = notice.id ?? ""
        self.title = "예매 시작 \(beforeMin)분 전입니다!"
        self.body = notice.title ?? ""
        let date = notice.openDateTime?.toDateType()
        //let newDate = Calendar.current.date(byAdding: .minute, value: -beforeMin, to: date)! //TODO: - newDate 변경
        let newDate = Calendar.current.date(byAdding: .second, value: beforeMin, to: Date())!
        self.date = newDate
        self.beforeMin = beforeMin
    }
}

enum LocalAlarmType: Codable {
    case five
    case ten
    case twenty
    case thirty
    
    var before: String {
        switch self {
        case .five:
            return "5분 전"
        case .ten:
            return "10분 전"
        case .twenty:
            return "20분 전"
        case .thirty:
            return "30분 전"
        }
    }
}
