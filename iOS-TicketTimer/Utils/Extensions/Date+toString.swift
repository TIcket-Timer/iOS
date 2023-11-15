//
//  Date+toString.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/15.
//

import UIKit

extension Date {
    public func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)! // 디바이스 기준 TimeZone 값
        
        return formatter.string(from: self)
    }
}
