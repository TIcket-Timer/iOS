//
//  String+toSiteType.swift
//  iOS-TicketTimer
//
//  Created by 심현석 on 2023/10/26.
//

import Foundation

extension String {
    func toSiteType() -> Platform {
        if self == "INTERPARK" {
            return .interpark
        } else if self == "MELON" {
            return .melon
        } else {
            return .yes24
        }
    }
}
