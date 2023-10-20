//
//  String+toDateAndTime.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/19.
//

import Foundation

extension String {
    func toDateAndTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        
        let date = dateFormatter.date(from: self)!
        
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatter.string(from: date)
    }
}
