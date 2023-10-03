//
//  Protocol.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/03.
//

import Foundation

// MARK: - 뷰모델 형식
public protocol ViewModelType {
	associatedtype Input
	associatedtype Output
	
	func transform(input: Input) -> Output
}
