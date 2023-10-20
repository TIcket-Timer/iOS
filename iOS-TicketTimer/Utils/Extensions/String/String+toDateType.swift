//
//  String+toDateType.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/19.
//

import Foundation

extension String {
    func toDateType() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        
        return dateFormatter.date(from: self)!
    }
}

