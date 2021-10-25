//
//  DetailedControllerView + Extension.swift
//  StocksKeeperMVVM
//
//  Created by dev on 10.10.21.
//

import UIKit
import SnapKit

extension DetailedControllerView {
    func makeBuyBlock() -> BuyBlockView {
        let view = BuyBlockView()
        view.delegateController = self.delegate
        view.delegateView = self
        view.setup()
        
        return view
    }
    
    func makeActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.style = .medium
        
        activityIndicator.hidesWhenStopped = true
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        return activityIndicator
    }
    
    func makeContentView() -> UIView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        
        let contentView = UIView()
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        return contentView
    }
    
    func makeStackView(name: String?, symbol: String?, description: String?, day: String?, dayBefore: String?, bookmarked: Bool?) -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 30
        stackView.axis = .vertical
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        let nameLabel = UILabel()
        nameLabel.text = name ?? "Name"
        nameLabel.font = UIFont.robotoMedium(withSize: 30)
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        
        let symbolLabel = UILabel()
        symbolLabel.text = symbol ?? "Symbol"
        symbolLabel.font = UIFont.robotoMedium(withSize: 25)
        symbolLabel.textColor = .gray
        
        let bookMarkLabel = UIButton()
        bookMarkLabel.tintColor = .red
        bookMarkLabel.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookMarkLabel.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        
        bookMarkLabel.isSelected = bookmarked ?? false
        bookMarkLabel.addTarget(self, action: #selector(addBookMark(sender:)), for: .touchUpInside)
        
        horizontalStack.addArrangedSubview(symbolLabel)
        horizontalStack.addArrangedSubview(bookMarkLabel)
        
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        bookMarkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        symbolLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width/2-25)
        }
        
        bookMarkLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width/2-25)
        }
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description ?? ""
        descriptionLabel.font = UIFont.robotoItalic(withSize: 25)
        descriptionLabel.numberOfLines = 0
        
        let stocksValuesBlock = configureStocksValues(day: day, dayBefore: dayBefore)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(horizontalStack)
        stackView.addArrangedSubview(stocksValuesBlock)
        stackView.addArrangedSubview(descriptionLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    func configureStocksValues(day: String?, dayBefore: String?) -> UIStackView {
        let horizontalStack = TouchableStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        
        let dayValueLabel = UILabel()
        dayValueLabel.text = String(format: "%.2f", Double(day ?? "0") ?? 0)
        dayValueLabel.font = UIFont.robotoMedium(withSize: 25)
        dayValueLabel.textAlignment = .center
        
        let dayBeforeLabel = UILabel()
        dayBeforeLabel.text = String(format: "%.2f", Double(dayBefore ?? "0") ?? 0)
        dayBeforeLabel.font = UIFont.robotoMedium(withSize: 20)
        dayBeforeLabel.textColor = .gray
        dayBeforeLabel.textAlignment = .center
        
        let arrowUpLabel = UIImageView(image: UIImage(systemName: "arrowtriangle.up.fill"))
        arrowUpLabel.tintColor = .green
        
        let arrowDownLabel = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill"))
        arrowDownLabel.tintColor = .red
        
        if let day = day, let dayBefore = dayBefore {
            if Float(day)! > Float(dayBefore)! {
                arrowDownLabel.tintColor = .gray
            } else {
                arrowUpLabel.tintColor = .gray
            }
        }
        
        let arrowStack = UIStackView()
        arrowStack.axis = .vertical
        arrowStack.spacing = 5
        
        arrowStack.addArrangedSubview(arrowUpLabel)
        arrowStack.addArrangedSubview(arrowDownLabel)
        
        arrowUpLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowDownLabel.translatesAutoresizingMaskIntoConstraints = false
        
        arrowUpLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2.2)
        }
        
        arrowDownLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().dividedBy(2.2)
        }
        
        stack.addArrangedSubview(dayValueLabel)
        stack.addArrangedSubview(dayBeforeLabel)
        
        dayBeforeLabel.translatesAutoresizingMaskIntoConstraints = false
        dayValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dayValueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2.2)
        }
        
        dayBeforeLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2.2)
        }
        
        let ZAGLUSHKAVIEW = UIView()
        
        horizontalStack.addArrangedSubview(stack)
        horizontalStack.addArrangedSubview(arrowStack)
        horizontalStack.addArrangedSubview(ZAGLUSHKAVIEW)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        arrowStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(buyBlockView)
        buyBlockView.translatesAutoresizingMaskIntoConstraints = false
        
        buyBlockView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return horizontalStack
    }
    
    @objc func addBookMark(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            saveStock()
        } else {
            sender.isSelected = false
            sender.setNeedsLayout()
            sender.layoutIfNeeded()
            deleteStock()
        }
    }
    
    func deleteStock() {
        delegate.viewModel?.delete(type: Stock.self, symbol: company.symbol)
    }
    
    func saveStock() {
        guard let stock = self.delegate.viewModel?.add(type: Stock.self) else { return }
        guard let company = company else { return }
        stock.name = company.name
        stock.desctiption = company.description
        stock.symbol = company.symbol
        stock.day = company.day
        stock.dayBefore = company.dayBefore
        stock.bookmarked = true
        delegate.viewModel?.save()
    }
}


class TouchableStackView: UIStackView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let inside = super.point(inside: point, with: event)
        
        if !inside {
            for subview in subviews {
                for subsubview in subview.subviews {
                    for subsubsubview in subsubview.subviews {
                        let pointInSubview = subsubsubview.convert(point, from: self)
                        if subsubsubview.point(inside: pointInSubview, with: event) {
                            return true
                        }
                    }
                }
            }
        }
        
        return inside
    }
}
