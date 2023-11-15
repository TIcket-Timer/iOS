//
//  String+toString.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/15.
//

import UIKit

extension String {
    public func toString(inputFormat: String, outputFormat: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        
        guard let date = inputFormatter.date(from: self)
        else {
            print("inputFormatter error")
            return nil
        }
        
        return outputFormatter.string(from: date)
    }
}
