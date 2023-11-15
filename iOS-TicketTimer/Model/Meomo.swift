//
//  Meomo.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/11/14.
//

import RxDataSources

struct Memo: Codable {
    var id: Int?
    var date: String?
    var content: String?
}

struct GetMemoResult: Codable {
    var memos: [Memo]
}

struct AddMemoResult: Codable {
    var id: Int?
    var date: String?
    var content: String?
}

struct MemoSection {
    var items: [Item]
    var header: String
}

extension MemoSection: SectionModelType {
    typealias Item = Memo
    
    init(original: MemoSection, items: [Memo]) {
        self = original
        self.items = items
    }
}

