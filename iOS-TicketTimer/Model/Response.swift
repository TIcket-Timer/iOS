//
//  File.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/07.
//

import Foundation

struct Response<T: Codable>: Codable {
	let code: Int
	let message: String
	let result: T?
}
