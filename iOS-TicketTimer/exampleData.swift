//
//  exampleData.swift
//  iOS-TicketTimer
//
//  Created by Jinhyung Park on 2023/08/02.
//

import Foundation

struct Data: Hashable {
    let imageName: String
    let interpark: String
    let title: String
    let place: String
    let date: String
}

extension Data {
    static let list = [
        Data(imageName: "opera", interpark: "interpark", title: "뮤지컬 <오페라의 유령>-서울", place: "샤롯데씨어터", date: "2023.07.12 14:00"),
        Data(imageName: "hest", interpark: "interpark", title: "뮤지컬 <라호 헤스트>", place: "드림아트센터 1관", date: "연.월.일 몇 시"),
        Data(imageName: "farinelli", interpark: "interpark", title: "뮤지컬 <파리넬리>-수원", place: "수원SK아트리움 대공연장", date: "연.월.일 몇 시"),
        Data(imageName: "opera", interpark: "interpark", title: "뮤지컬 <오페라의 유령>-서울", place: "샤롯데씨어터", date: "2023.07.13 14:00"),
        Data(imageName: "hest", interpark: "interpark", title: "뮤지컬 <라호 헤스트>", place: "드림아트센터 2관", date: "연.월.일 몇 시")
    ]
}
