//
//  BagViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 16.10.21.
//

import UIKit

class BagViewController: UIViewController {
    var viewModel: BagViewModelProtocol?
    
    lazy var searchBar = SearchBar()
    
    var bags: [StocksBag]? {
        didSet {
            configureCover(show: bags?.isEmpty ?? false)
        }
    }
    
    lazy var emptyBagLabel: UILabel = {
        let label = UILabel()
        label.text = "Add some bags!"
        label.font = UIFont.robotoBold(withSize: 24)
        label.textColor = .lightGray
        
        return label
    }()
    
    lazy var bagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .white
        
        return view
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBags()
        configureSearchBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        fetchBags()
        configureTabBar()
        configureBagCollectionView()
        configureSearchBar()
    }
    
    func fetchBags() {
        let array = viewModel?.fetchBags()?.sorted(by: { bag1, bag2 in
            bag1.name! < bag2.name!
        })
        bags = array
        bagCollectionView.reloadData()
    }
    
    @objc func addBag(sender: UIBarButtonItem) {
        setupScreenForPopUp(check: true)
        setupPopUp()
    }
    
    @objc func createBag(sender: UIButton, name: String) {
        guard let newBag = viewModel?.add(type: StocksBag.self) else { return }
        newBag.name = name
        newBag.profit = 0
        viewModel?.save()
        fetchBags()
        bagCollectionView.reloadData()
        sender.superview?.superview?.removeFromSuperview()
        setupScreenForPopUp(check: false)
    }
    
    @objc func viewTouchedWhenPopUpViewOnTop(sender: UITapGestureRecognizer?) {
        guard let view = sender?.view else { return }
        animate(in: false, sender: view)
        setupScreenForPopUp(check: false)
    }
    
    @objc func removeBag(sender: BagCollectionViewCell) {
        let alert = UIAlertController(title: "Delete This Bag?", message: "Are you sure you want to delete this bag? All related data will be removed as well!", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let bagIndexPath = self?.bagCollectionView.indexPath(for: sender) else { return }
            guard let bagToRemove = self?.bags?[bagIndexPath.row] else { return }
            self?.removeBag(bag: bagToRemove)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func removeBag(bag: StocksBag) {
        viewModel?.delete(object: bag)
        fetchBags()
        bagCollectionView.reloadData()
    }
    
    func updateView() {
        viewModel?.updateViewData = { [weak self] viewData in
            self?.searchBar.viewData = viewData
        }
    }
    
    func initiateSearch(_ check: Bool) {
        if check {
            searchBar.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
            searchBar.searchTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            
            view.addSubview(searchBar.searchTableView)
            searchBar.searchTableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                searchBar.searchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                searchBar.searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
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
    
    @objc func searchButtonTapped(sender: UIButton) {
        initiateSearch(true)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.navigationItem.titleView = self?.searchBar
            self?.searchBar.showsCancelButton = true
            self?.searchBar.becomeFirstResponder()
            self?.navigationItem.rightBarButtonItem = nil
            self?.navigationItem.leftBarButtonItem = nil
        })
    }
}

extension BagViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.startFetch(withSymbol: searchText)
        updateView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        initiateSearch(false)
        configureSearchBar()
        searchBar.resignFirstResponder()
    }
}

extension BagViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController((UIApplication.shared.delegate as! AppDelegate).router.createStocksBagModule(withBag: (bags?[indexPath.row])!), animated: true)
    }
}

extension BagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2-20, height: UIScreen.main.bounds.width/2-20)
    }
}

extension BagViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bags?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BagCollectionViewCell.identifier, for: indexPath) as! BagCollectionViewCell
        let item = bags?[indexPath.row]
        cell.bagName = bags?[indexPath.row].name
        cell.cost = bags?[indexPath.row].realProfit
        cell.delegate = self
        cell.configureCell()
        return cell
    }
}

