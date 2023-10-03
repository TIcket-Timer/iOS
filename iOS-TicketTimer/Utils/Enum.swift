//
//  Enums.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import Foundation

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
