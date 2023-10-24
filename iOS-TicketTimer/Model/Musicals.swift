//
//  Musicals.swift
//  iOS-TicketTimer
//
//  Created by 김지현 on 2023/10/07.
//

import Foundation

struct Musicals: Codable, Equatable {
	let createdTime: String?
	let modifiedDate: String?
	let id: String?
	let siteCategory: String?
    let title: String?
    let posterUrl: String?
    let startDate: String?
    let endDate: String?
    let place: String?
    let runningTime: String?
    let siteLink: String?
	let actors: [Actor?]
}

struct Actor: Codable, Equatable {
    let actorId: Int?
    let actorName: String?
    let profileUrl: String?
    //let siteCategory: String?
    let roleName: String
}

struct MusicalNotice: Codable, Equatable {
    let id: String?
    let siteCategory: String?
    let openDateTime: String?
    let title: String?
    let url: String?
}
