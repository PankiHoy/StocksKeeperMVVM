//
//  CompaniesData.swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation

enum ViewData {
    case initial
    case loading(CompaniesData)
    case success(CompaniesData)
    case failure(CompaniesData)
    
    struct CompaniesData: Codable {
        struct Company: Codable {
            let symbol: String?
            let name: String?
            
            enum CodingKeys: String, CodingKey {
                case symbol = "1. symbol"
                case name = "2. name"
            }
        }
        var companiesList: [Company]?
        
        enum CodingKeys: String, CodingKey {
            case companiesList = "bestMatches"
        }
    }
}
