//
//  BuyBlockTableViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 19.10.21.
//

import UIKit

struct BuyCell {
    var opened: Bool
    var title: String
    var sectionData: [StocksBag]
}

class BuyBlockView: UIView {
    var delegateController: DetailedStockViewController?
    var delegateView: DetailedControllerView?
    var buyCell: BuyCell?
    
    lazy var tableView: DinamicTableView = {
        let view = DinamicTableView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        
        return view
    }()
    
    func setup() {
        fetchData()
        configureTableView()
    }
    
    func fetchData() {
        guard let bags = delegateController?.viewModel?.fetchBags() else { return }
        buyCell = BuyCell(opened: false, title: "BUY", sectionData: bags)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "buyTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "bagsTableViewCell")
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension BuyBlockView: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = buyCell?.sectionData.count else { return 1 }
        if buyCell?.opened == true {
            return count+1
        } else {
            return 1
        }
    }
}

extension BuyBlockView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndexPath = indexPath.row-1
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buyTableViewCell")
            cell?.textLabel?.text = buyCell?.title
            cell?.textLabel?.textAlignment = .center
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bagsTableViewCell")
            cell?.textLabel?.text = buyCell?.sectionData[dataIndexPath].name
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if buyCell?.opened == true {
            if indexPath.row > 0 {
                let cell = tableView.visibleCells[indexPath.row]
                guard let bagName = cell.textLabel?.text else { return }
                guard let bag = delegateController?.viewModel?.fetchBag(name: bagName) else { return }
                guard let stock = getStock() else { return }
                bag.addToStocks(stock)
                bag.profit += stock.cost
                delegateController?.viewModel?.save()
            }
            buyCell?.opened = false
            tableView.reloadData()
        } else {
            buyCell?.opened = true
            tableView.reloadData()
        }
    }
    
    func getStock() -> StockToBuy? {
        guard let company = delegateView?.company else { return nil }
        guard let stock = delegateController?.viewModel?.add(type: StockToBuy.self) else { return nil }
        stock.name = company.name
        stock.day = company.day
        stock.dayBefore = company.dayBefore
        stock.dateOfBuying = Date()
        stock.cost = Double(company.day ?? "0") ?? 0
        
        return stock
    }
}
