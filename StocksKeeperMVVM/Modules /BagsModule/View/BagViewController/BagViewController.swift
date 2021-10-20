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
    
    var bags: [StocksBag]?
    
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        fetchBags()
        configureTabBar()
        configureBagCollectionView()
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
        guard let bagToRemoveName = sender.bagName else { return }
        removeBag(bagName: bagToRemoveName)
    }
    
    private func removeBag(bagName name: String) {
        guard let bagToRemove = viewModel?.fetchBag(name: name) else { return }
        viewModel?.delete(object: bagToRemove)
        fetchBags()
        bagCollectionView.reloadData()
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
        cell.cost = bags?[indexPath.row].profit
        cell.delegate = self
        cell.configureCell()
        return cell
    }
    
}
