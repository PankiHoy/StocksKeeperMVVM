//
//  ExpandableCollectionViewCell.swift
//  StocksKeeperMVVM
//
//  Created by dev on 20.10.21.
//

import UIKit
import SnapKit

class ExpandableCollectionViewCell: UICollectionViewCell {
    static let identifier = "stocksCell"
    
    var generalStock: GeneralStock?
    
    private lazy var generalStockNameLabel = UILabel()
    private lazy var generalAverageCostLabel = UILabel()
    private lazy var generalProfitLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private var expandedConstaint: Constraint!
    private var collapsedConstraint: Constraint!
    
    private lazy var mainContainer = UIView()
    private lazy var topContainer = UIView()
    private lazy var bottomContainer = UIView()
    
    private lazy var arrowImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "arrow_down")!.withRenderingMode(.alwaysTemplate))
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private func updateAppearance() {
        collapsedConstraint.isActive = !isSelected
        expandedConstaint.isActive = isSelected
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999)
            self?.arrowImageView.transform = self?.isSelected ?? false ? upsideDown : .identity
        })
    }
    
    func configureCell(withStock stock: GeneralStock!) {
        generalStock = stock
        mainContainer.clipsToBounds = true
        topContainer.backgroundColor = .lightLightGray
        bottomContainer.backgroundColor = .white
        
        makeConstraints()
        updateAppearance()
        
        configureTopContainerLabels()
        configureBottomContainerLabels()
        
        configureEffects()
    }
    
    func configureTopContainerLabels() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        
        let costStack = UIStackView()
        costStack.axis = .horizontal
        costStack.spacing = 5
        
        generalStockNameLabel.text = generalStock?.name
        generalStockNameLabel.font = UIFont.robotoItalic(withSize: 24)
        generalStockNameLabel.textColor = .black
        
        generalAverageCostLabel.text = String(format: "%0.2f", generalStock?.currentAverageCost ?? 0)
        generalAverageCostLabel.font = UIFont.robotoItalic(withSize: 24)
        generalAverageCostLabel.textColor = .black
        generalAverageCostLabel.textAlignment = .right
        
        let difference = ((generalStock?.currentLatestCost ?? 0)-(generalStock?.currentAverageCost ?? 0))
        
        generalProfitLabel.text = difference>0 ? String(format: "+%.2f", difference) : String(format: "%.2f", difference)
        generalProfitLabel.font = UIFont.robotoItalic(withSize: 18)
        generalProfitLabel.textAlignment = .left
        
        if difference > 0 {
            generalProfitLabel.textColor = .green
        } else {
            generalProfitLabel.textColor = .red
        }
        
        stack.addArrangedSubview(generalStockNameLabel)
        generalStockNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            generalStockNameLabel.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.35)
        ])
        
        costStack.addArrangedSubview(generalAverageCostLabel)
        costStack.addArrangedSubview(generalProfitLabel)
        generalAverageCostLabel.translatesAutoresizingMaskIntoConstraints = false
        generalProfitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        generalAverageCostLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        generalProfitLabel.snp.makeConstraints { make in
            make.width.equalTo(80)
        }
        
        stack.addArrangedSubview(costStack)
        costStack.translatesAutoresizingMaskIntoConstraints = false
        
        costStack.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(0.4)
        }
        
        stack.addArrangedSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        arrowImageView.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.width.equalTo(18)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        topContainer.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func configureBottomContainerLabels() {
        guard let stocksArray = generalStock?.subStocksArray else { return }
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .vertical
        
        let horizontalGeneralStack = UIStackView()
        horizontalGeneralStack.axis = .horizontal
        horizontalGeneralStack.spacing = 10
        
        let stockNameLabel = MyLabel(withFont: nil, color: .darkerGray!, andText: "Name")
        let stockDateLabel = MyLabel(withFont: nil, color: .darkerGray!, andText: "Date")
        let stockAmountLabel = MyLabel(withFont: nil, color: .darkerGray!, andText: "AMT")
        let stockCostLabel = MyLabel(withFont: nil, color: .darkerGray!, andText: "Buy")
        
        horizontalGeneralStack.addArrangedSubview(stockNameLabel)
        horizontalGeneralStack.addArrangedSubview(stockDateLabel)
        horizontalGeneralStack.addArrangedSubview(stockAmountLabel)
        horizontalGeneralStack.addArrangedSubview(stockCostLabel)
        
        NSLayoutConstraint.activate([
            stockNameLabel.widthAnchor.constraint(equalTo: horizontalGeneralStack.widthAnchor, multiplier: 0.25),
            stockDateLabel.widthAnchor.constraint(equalTo: horizontalGeneralStack.widthAnchor, multiplier: 0.3),
            stockCostLabel.widthAnchor.constraint(equalTo: horizontalGeneralStack.widthAnchor, multiplier: 0.25),
            stockAmountLabel.widthAnchor.constraint(equalTo: horizontalGeneralStack.widthAnchor, multiplier: 0.14)
        ])
        
        stockCostLabel.textAlignment = .center
        stockAmountLabel.textAlignment = .center
        
        stack.addArrangedSubview(horizontalGeneralStack)
        horizontalGeneralStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalGeneralStack.topAnchor.constraint(equalTo: stack.topAnchor, constant: 5),
            horizontalGeneralStack.widthAnchor.constraint(equalTo: stack.widthAnchor, constant: -20),
            horizontalGeneralStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 10)
        ])
        
        for stock in stocksArray.sorted(by: { $0.dateOfBuying! > $1.dateOfBuying! }) {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.spacing = 10
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            let date = dateFormatter.date(from: stock.dateOfBuying!.description)
            dateFormatter.dateFormat = "MMM dd yyyy"
            
            let stockNameLabel = MyLabel(withFont: nil, color: .lightGray, andText: stock.name)
            let stockDateLabel = MyLabel(withFont: nil, color: .lightGray, andText: dateFormatter.string(from: date!))
            let stockAmountLabel = MyLabel(withFont: nil, color: .lightGray, andText: "\(stock.amount)")
            let stockCostLabel = MyLabel(withFont: nil, color: .lightGray, andText: String(format: "%.2f", stock.cost))
            
            stockAmountLabel.textAlignment = .center
            stockCostLabel.textAlignment = .center
            
            horizontalStack.addArrangedSubview(stockNameLabel)
            horizontalStack.addArrangedSubview(stockDateLabel)
            horizontalStack.addArrangedSubview(stockAmountLabel)
            horizontalStack.addArrangedSubview(stockCostLabel)
            
            NSLayoutConstraint.activate([
                stockNameLabel.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.25),
                stockDateLabel.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.3),
                stockCostLabel.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.25),
                stockAmountLabel.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.14)
            ])
            
            stack.addArrangedSubview(horizontalStack)
            horizontalStack.translatesAutoresizingMaskIntoConstraints = false
            
            horizontalStack.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.right.equalToSuperview().offset(-10)
            }
        }
        
        bottomContainer.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func configureEffects() {
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
    }
    
    func makeConstraints() {
        contentView.addSubview(mainContainer)
        
        mainContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainContainer.addSubview(topContainer)
        mainContainer.addSubview(bottomContainer)
        
        topContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        topContainer.snp.prepareConstraints { make in
            collapsedConstraint = make.bottom.equalToSuperview().constraint
            collapsedConstraint.layoutConstraints.first?.priority = .defaultLow
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(topContainer.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        bottomContainer.snp.prepareConstraints { make in
            expandedConstaint = make.bottom.equalToSuperview().constraint
            expandedConstaint.layoutConstraints.first?.priority = .defaultLow
        }
    }
    
}
