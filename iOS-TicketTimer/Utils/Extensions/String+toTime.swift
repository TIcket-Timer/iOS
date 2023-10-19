//
//  String+toTime.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/18.
//

import Foundation

extension String {
    func toTime() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        
        let date = dateFormatter.date(from: self)!
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
