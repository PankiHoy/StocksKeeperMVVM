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
    
    lazy var countTextField: UITextField = {
        let countTextField = UITextField()
        countTextField.text = "1"
        countTextField.textAlignment = .center
        countTextField.textColor = .black
        countTextField.layer.borderWidth = 0.8
        countTextField.layer.borderColor = UIColor.lightLightGray?.cgColor
        countTextField.tintColor = .black
        
        return countTextField
    }()
    
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
        configureCountTextField()
    }
    
    func fetchData() {
        guard let bags = delegateController?.viewModel?.fetchBags()?.sorted(by: { $0.name! < $1.name! }) else { return }
        buyCell = BuyCell(opened: false, title: "BUY", sectionData: bags)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "buyTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "bagTableViewCell")
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 110),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -85),
        ])
    }
    
    func configureCountTextField() {
        addSubview(countTextField)
        countTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countTextField.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            countTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            countTextField.widthAnchor.constraint(equalToConstant: 50),
            countTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func tableViewTouched(sender: UITapGestureRecognizer) {
        let point = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if buyCell?.opened == true {
            if indexPath!.row > 0 {
                buyStock(indexPath: indexPath!)
                delegateController?.viewModel?.save()
            }
            buyCell?.opened = false
            tableView.reloadData()
        } else {
            buyCell?.opened = true
            tableView.reloadData()
            countTextField.resignFirstResponder()
        }
    }
}

extension BuyBlockView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self {
            return nil
        }
        return view
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "bagTableViewCell")
            cell?.textLabel?.text = buyCell?.sectionData[dataIndexPath].name
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if buyCell?.opened == true {
            if indexPath.row > 0 {
                buyStock(indexPath: indexPath)
                delegateController?.viewModel?.save()
            }
            buyCell?.opened = false
            countTextField.resignFirstResponder()
            tableView.reloadData()
        } else {
            buyCell?.opened = true
            countTextField.resignFirstResponder()
            tableView.reloadData()
            tableView.setNeedsLayout()
            tableView.layoutIfNeeded()
        }
    }
    
    func buyStock(indexPath: IndexPath) {
        let cell = tableView.visibleCells[indexPath.row]
        guard let bagName = cell.textLabel?.text else { return }
        guard let bag = delegateController?.viewModel?.fetchBag(name: bagName) else { return }
        guard let company = delegateView?.company else { return }
        
        if let generalStock = bag.stocksArray.first(where: { $0.name == company.name }) {
            /* this is just for case where i want to add by date(not by time) if let duplicateStock = generalStock.subStocksArray.first(where: { $0.dateOfBuying == Date() }) /*MARK: - KOSTIL' */ {
                duplicateStock.amount += 1
                delegateController?.viewModel?.save()
                return
            } else { */
            guard let subStock = addStock(withData: company) else { return }
            subStock.amount = Int64(countTextField.text!) ?? 1
            subStock.cost = ((Double(subStock.day ?? "0") ?? 0) * Double(subStock.amount))
            generalStock.addToSubStocks(subStock)
            delegateController?.viewModel?.save()
            return
        }
        
        guard let generalStock = delegateController?.viewModel?.add(type: GeneralStock.self) else { return }
        guard let subStock = addStock(withData: company) else { return }
        generalStock.addToSubStocks(subStock)
        generalStock.name = company.name
        generalStock.reloadAverageCost()
        
        bag.addToStocks(generalStock)
        
        delegateController?.viewModel?.save()
    }
    
    func addStock(withData data: DetailedViewData.CompanyOverview) -> StockToBuy? {
        guard let subStock = delegateController?.viewModel?.add(type: StockToBuy.self) else { return nil }
        subStock.symbol = data.symbol
        subStock.name = data.name
        subStock.day = data.day
        subStock.dayBefore = data.dayBefore
        subStock.dateOfBuying = Date()
        subStock.amount = 1
        subStock.cost = Double(subStock.amount) * Double(subStock.day ?? "0")!
        
        return subStock
    }
}
