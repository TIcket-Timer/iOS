//
//  Enums.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import Foundation
import UIKit

enum Server: String, Codable {
	case baseUrl = "http://43.202.78.122:8080"
}

enum Keys: String, Codable {
	case kakao = "146854dc657d698352dbda87b92c20b1"
}

enum Tab: Int {
	case Home, Show, Calendar, Settings
}

// MARK: - 뷰컨과 뷰모델 사이에 넘겨줄 데이터 타입
enum Execution<T> {
	case trigger // 넘겨줄 데이터가 없을때
	case success(_ data: T)
	case error(_ errorMessage: String)
}

enum Platform: String {
    case interpark = "인터파크"
    case melon = "멜론"
    case yes24 = "yse24"
    
    var ticket: String {
        switch self {
        case .interpark:
            return "인터파크 티켓"
        case .melon:
            return "멜론 티켓"
        case .yes24:
            return "yes24 티켓"
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
