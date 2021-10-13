//
//  CompaniesData.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation

enum DetailedViewData {
    case initial
    case loading(CompanyOverview)
    case success(CompanyOverview)
    case failure(CompanyOverview)
    
    struct CompanyOverview: Codable {
        let name: String?
        let symbol: String?
        let description: String?
        let day: String?
        let dayBefore: String?
        let bookmarked: Bool?
        
        enum CodingKeys: String, CodingKey {
            case name
            case symbol
            case description
            case day = "AnalustTargetPrice"
            case dayBefore = "50DayMovingAverage"
            case bookmarked
        }
    }
}
