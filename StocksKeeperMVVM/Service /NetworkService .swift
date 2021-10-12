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
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let data = data {
                    let company = try JSONDecoder().decode(DetailedViewData.CompanyOverview.self, from: data)
                    completion(.success(company))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}
