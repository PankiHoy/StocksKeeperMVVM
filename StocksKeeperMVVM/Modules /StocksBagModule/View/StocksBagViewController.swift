//
//  StocksBagViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 14.10.21.
//

import UIKit

class StocksBagViewController: UIViewController {
    var viewModel: StocksBagViewModel!
    var bag: StocksBag?
    
    let searchBar = SearchBar()
    
    lazy var stocksTableView: DinamicTableView = {
        let tableView = DinamicTableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = .lightGray
        tableView.layer.cornerRadius = 20
        
        return tableView
    }()
    
    lazy var profitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.robotoBold(withSize: 30)
        label.textColor = .white
        label.text = "TOTAL PROFIT \n\n\(Int(bag?.profit ?? 0)) $USD"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stocksTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    init(withBag bag: StocksBag) {
        super.init(nibName: nil, bundle: nil)
        self.bag = bag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        view.backgroundColor = .white
        
        configureTabBar()
        configureTableView()
        configureSellButton()
    }
    
    func configureTabBar() {
        tabBarController?.tabBar.isHidden = false
        tabBarItem = UITabBarItem(title: "Your Stocks",
                                  image: UIImage(systemName: "bag"),
                                  selectedImage: UIImage(systemName: "bag.fill"))
        tabBarController?.tabBar.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "banknote"), style: .plain, target: self, action: #selector(withdraw(sender:)))
        title = bag?.name
    }
    
    func configureTableView() {
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.register(StocksBagTableViewCell.self, forCellReuseIdentifier: StocksBagTableViewCell.identifier)
        
        view.addSubview(stocksTableView)
        stocksTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stocksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stocksTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stocksTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    func configureSellButton() {
        let sellButton = UIButton()
        sellButton.setImage(UIImage(systemName: "dollarsign.circle"), for: .normal)
        sellButton.setImage(UIImage(systemName: "dollarsign.circle.fill"), for: .highlighted)
        sellButton.setTitle("  SELL  ", for: .normal)
        sellButton.titleLabel?.font = UIFont.robotoBold(withSize: 30)
        sellButton.titleLabel?.textColor = .black
        sellButton.titleLabel?.highlightedTextColor = .black
        sellButton.tintColor = .black
        sellButton.layer.cornerRadius = 20
        sellButton.layer.borderWidth = 2
        sellButton.layer.borderColor = UIColor.white.cgColor
        
        sellButton.addTarget(self, action: #selector(sellEverything(sender:)), for: .touchUpInside)
        
        let sellContentView = UIView()
        sellContentView.backgroundColor = .lightLightGray
        sellContentView.layer.cornerRadius = 20
        
        view.addSubview(sellContentView)
        sellContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sellContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            sellContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            sellContentView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height/2 + 10),
            sellContentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
        
        sellContentView.addSubview(sellButton)
        sellButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sellButton.topAnchor.constraint(equalTo: sellContentView.topAnchor, constant: 50),
            sellButton.centerXAnchor.constraint(equalTo: sellContentView.centerXAnchor),
            sellButton.heightAnchor.constraint(equalToConstant: 50),
            sellButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        sellContentView.addSubview(profitLabel)
        profitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profitLabel.topAnchor.constraint(equalTo: sellContentView.topAnchor, constant: 130),
            profitLabel.centerXAnchor.constraint(equalTo: sellContentView.centerXAnchor)
        ])
    }
    
    func initiateSearch(_ check: Bool) {
        if check {
            searchBar.searchTableView.delegate = self
            searchBar.searchTableView.dataSource = self
            
            searchBar.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            searchBar.searchTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
            
            view.addSubview(searchBar.searchTableView)
            searchBar.searchTableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                searchBar.searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                searchBar.searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
            ])
        } else {
            if view.subviews.contains(searchBar.searchTableView) {
                view.willRemoveSubview(searchBar.searchTableView)
                searchBar.searchTableView.removeFromSuperview()
                navigationItem.titleView = nil
            }
        }
    }
    
    func updateView() {
        viewModel.updateViewData = { [weak self] viewData in
            self?.searchBar.viewData = viewData
        }
    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        initiateSearch(true)
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
    }
    
    @objc func sellEverything(sender: UIButton) {
        for stock in bag!.stocksArray {
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.reloadProfit(withAmount: stock.cost)
                self?.bag?.removeFromStocks(stock)
                self?.viewModel.save()
                self?.stocksTableView.reloadData()
            })
        }
    }
    
    func reloadProfit(withAmount amount: Double) {
        bag?.profit += amount
        profitLabel.text = "TOTAL PROFIT \n\n\(Int(bag?.profit ?? 0)) $USD"
        profitLabel.setNeedsLayout()
        profitLabel.layoutIfNeeded()
    }
    
    @objc func withdraw(sender: UIBarButtonItem) {
        bag?.profit = 0
        reloadProfit(withAmount: 0)
        viewModel.save()
    }
}

extension StocksBagViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedController = (UIApplication.shared.delegate as! AppDelegate).router.createDetailedStockModule(withSymbol: bag?.stocksArray[indexPath.row].symbol ?? "AAPL")
        navigationController?.pushViewController(detailedController, animated: true)
    }
}

extension StocksBagViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bag?.stocks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StocksBagTableViewCell.identifier) as? StocksBagTableViewCell
        cell?.nameLabel.text = bag?.stocksArray[indexPath.row].name
        cell?.amountLabel.text = String(bag?.stocksArray[indexPath.row].amount ?? 0)
        cell?.costLabel.text = String(format: "%.1f", bag?.stocksArray[indexPath.row].cost ?? 0)
        cell?.configureCell()
        
        return cell!
    }
    
    
}
