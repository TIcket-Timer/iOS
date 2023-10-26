//
//  String+toDate.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/18.
//

import Foundation

extension String {
    func toDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        
        let date = dateFormatter.date(from: self)!
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    func toDateKor() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let date = dateFormatter.date(from: self)!
        
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        return dateFormatter.string(from: date)
    }
}

