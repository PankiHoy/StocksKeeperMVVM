//
//  StocksBagViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 14.10.21.
//

import UIKit

class StocksBagViewController: UIViewController {
    private var sizingCell: ExpandableCollectionViewCell?
    
    var viewModel: StocksbagViewModelPrototocol?
    var bag: StocksBag?
    
    private var emptyBagLabel: UILabel = {
        let label = UILabel()
        label.text = "This bag is empty rolfanHmm"
        label.font = UIFont.robotoBold(withSize: 24)
        label.textColor = .lightGray
        
        return label
    }()
    
    private lazy var stocksCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.allowsMultipleSelection = true
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        
        return view
    }()
    
    init(withBag bag: StocksBag) {
        self.bag = bag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCover(show: bag?.stocksArray.isEmpty ?? true)
        stocksCollection.reloadData()
    }
    
    override func viewDidLoad() {
        let realodButton = ReloadBarButtonItem()
        realodButton.delegate = self
        navigationItem.setRightBarButton(realodButton, animated: true)
        title = bag?.name
        
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        configureStocksCollection()
    }

    @objc func sellAllStocks(sender: UIBarButtonItem) {
        viewModel?.deleteAll(type: GeneralStock.self)
    }
    
    func configureCover(show: Bool) {
        if show {
            if !view.contains(emptyBagLabel) {
                view.addSubview(emptyBagLabel)
                emptyBagLabel.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    emptyBagLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    emptyBagLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
            }
        } else {
            if view.subviews.contains(emptyBagLabel) {
                emptyBagLabel.removeFromSuperview()
            }
        }
    }
    
    func configureStocksCollection() {
        stocksCollection.delegate = self
        stocksCollection.dataSource = self
        stocksCollection.register(ExpandableCollectionViewCell.self, forCellWithReuseIdentifier: ExpandableCollectionViewCell.identifier)
        
        view.addSubview(stocksCollection)
        stocksCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stocksCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stocksCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stocksCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stocksCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension StocksBagViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        
        DispatchQueue.main.async {
            guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }
            
            let desiredOffset = attributes.frame.origin.y-20
            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            let maxPossibleOffset = contentHeight - collectionView.bounds.height
            let finalOffset = max(min(desiredOffset, maxPossibleOffset), 0)
            
            collectionView.setContentOffset(CGPoint(x: 0, y: finalOffset), animated: true)
        }
        
        return true
    }
}

extension StocksBagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        
        sizingCell = ExpandableCollectionViewCell()
        sizingCell?.frame = CGRect(
            origin: .zero,
            size: CGSize(width: collectionView.bounds.width - 40, height: 1000)
        )
        
        sizingCell?.configureCell(withStock: bag?.stocksArray[indexPath.row])
        sizingCell?.isSelected = isSelected
        sizingCell?.setNeedsLayout()
        sizingCell?.layoutIfNeeded()

        let size = sizingCell?.systemLayoutSizeFitting(
            CGSize(width: collectionView.bounds.width - 40, height: .greatestFiniteMagnitude),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        sizingCell = nil

        return size!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}

extension StocksBagViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bag?.stocks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpandableCollectionViewCell.identifier, for: indexPath) as? ExpandableCollectionViewCell
        cell?.configureCell(withStock: bag?.stocksArray[indexPath.row])
        
        return cell!
    }
}

extension StocksBagViewController: ControllerWithReloadProtocol {
    func reloadViewData(sender: UIBarButtonItem) {
        
    }
}
