//
//  NetworkService .swift
//  StocksKeeperMVVM
//
//  Created by dev on 8.10.21.
//

import Foundation

protocol NetworkServiceProtocol {
    func getCompaniesList(bySymbol: String, completion: @escaping (Result<[ViewData.CompaniesData.Company]?, Error>) -> Void)
    func getCompanyOverview(bySymbol: String, completion: @escaping (Result<DetailedViewData.CompanyOverview?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let session = URLSession(configuration: .default)
    
    func getCompaniesList(bySymbol symbol: String, completion: @escaping (Result<[ViewData.CompaniesData.Company]?, Error>) -> Void) {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=6O8FZ2GBGJR485JE"
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let data = data {
                    let companiesDict = try JSONDecoder().decode(ViewData.CompaniesData.self, from: data)
                    let companiesList = companiesDict.companiesList
                    completion(.success(companiesList))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func getCompanyOverview(bySymbol symbol: String, completion: @escaping (Result<DetailedViewData.CompanyOverview?, Error>) -> Void) {
        let urlString = "https://www.alphavantage.co/query?function=OVERVIEW&symbol=\(symbol)&apikey=6O8FZ2GBGJR485JE"
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let data = data {
                    let companyJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                    let data = self?.parseCompanyOverviewJson(data: companyJson ?? [:])
                    completion(.success(data))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func parseCompanyOverviewJson(data: [String: String]) -> DetailedViewData.CompanyOverview {
        let company = DetailedViewData.CompanyOverview(name: data["Name"] ?? nil,
                                                       symbol: data["Symbol"] ?? nil,
                                                       description: data["Description"] ?? nil,
                                                       day: data["50DayMovingAverage"] ?? nil,
                                                       dayBefore: data["200DayMovingAverage"] ?? nil,
                                                       bookmarked: nil)
        
        return company
    }
    
}
