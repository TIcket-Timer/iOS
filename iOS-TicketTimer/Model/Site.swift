//
//  Site.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/07.
//

import UIKit

enum Site: String, CaseIterable {
    case interpark = "인터파크"
    case melon = "멜론"
    case yes24 = "yse24"
    
    var siteLowercase: String {
        switch self {
        case .interpark:
            return "interpark"
        case .melon:
            return "melon"
        case .yes24:
            return "yes24"
        }
    }
    
    var siteUppercase: String {
        switch self {
        case .interpark:
            return "INTERPARK"
        case .melon:
            return "MELON"
        case .yes24:
            return "YES24"
        }
    }
    
    var ticket: String {
        switch self {
        case .interpark:
            return "인터파크 티켓"
        case .melon:
            return "멜론 티켓"
        case .yes24:
            return "yes24"
        }
    }
    
    var color: UIColor {
        switch self {
        case .interpark:
            return UIColor("#8447DF")
        case .melon:
            return UIColor.mainColor
        case .yes24:
            return UIColor("#377EF7")
        }
    }
}
