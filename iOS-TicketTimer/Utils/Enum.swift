//
//  Enums.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import Foundation
import UIKit

enum Server: String, Codable {
	case baseUrl = "https://nengcipe-server.store"
}

enum Keys: String, Codable {
	case kakao = "1237cdb96724bfb06de71c875f8d5132"
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

enum Platform: String, CaseIterable {
    case interpark = "인터파크"
    case melon = "멜론"
    case yes24 = "yse24"
    
    var site: String {
        switch self {
        case .interpark:
            return "interpark"
        case .melon:
            return "melon"
        case .yes24:
            return "yes24"
        }
    }
    
    var siteCapital: String {
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

enum TestToken: String {
    case accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJzZXJ2ZXJJZCI6Imtha2FvMjgwMzE2MzU4NyIsImlkIjoxLCJ0eXBlIjoiYWNjZXNzVG9rZW4iLCJpYXQiOjE2OTY1OTI4MDIsImV4cCI6MTY5OTU5MjgwMn0.8fVYvhAI2LP_RsgR0VNIYljLSuv6cCv5tkV3NunKJL4"
    case refreshToken = "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwic2VydmVySWQiOiJrYWthbzI4MDMxNjM1ODciLCJ0eXBlIjoicmVmcmVzaFRva2VuIiwiaWF0IjoxNjk2NTkyODAyLCJleHAiOjE3MDI1OTI4MDJ9.a0hmTd92_Cw3OA1XdDTl65eqbChz8bo9c4oWMPK967c"
    case accessToken_expired = "eyJhbGciOiJIUzI1NiJ9.eyJzZXJ2ZXJJZCI6Imtha2FvMjgwMzE2MzU4NyIsImlkIjoxLCJ0eXBlIjoiYWNjZXNzVG9rZW4iLCJpYXQiOjE2OTY3NDg2OTYsImV4cCI6MTY5Njc0ODY5Nn0.MKPwZnIsZ4a7qCJjefHCw-_vsqCw9G4DdLyeeF6-lo8"
    case refreshToken_expired = "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwic2VydmVySWQiOiJrYWthbzI4MDMxNjM1ODciLCJ0eXBlIjoicmVmcmVzaFRva2VuIiwiaWF0IjoxNjk2NzQ4Njk2LCJleHAiOjE2OTY3NDg2OTZ9.DqTWSY9pDqAB-iz3w0mjaIDJygwWau8XOOISN7OJDOs"
}

enum SearchType {
    case notice
    case musical
}
