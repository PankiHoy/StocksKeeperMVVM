//
//  DetailedControllerView + Extension.swift
//  StocksKeeperMVVM
//
//  Created by dev on 10.10.21.
//

import UIKit

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
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let contentView = UIView()
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
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

        symbolLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
        bookMarkLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2).isActive = true
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = description ?? ""
        descriptionLabel.font = UIFont.robotoItalic(withSize: 25)
        descriptionLabel.numberOfLines = 0
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(horizontalStack)
        stackView.addArrangedSubview(configureStocksValues(day: day, dayBefore: dayBefore))
        stackView.addArrangedSubview(descriptionLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 50),
            descriptionLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -30)
        ])
        
        return stackView
    }
    
    func configureStocksValues(day: String?, dayBefore: String?) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        
        let dayValueLabel = UILabel()
        dayValueLabel.text = day ?? "0"
        dayValueLabel.font = UIFont.robotoMedium(withSize: 25)
        dayValueLabel.textAlignment = .center
        
        let dayBeforeLabel = UILabel()
        dayBeforeLabel.text = dayBefore ?? "0"
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
        
        NSLayoutConstraint.activate([
            arrowUpLabel.heightAnchor.constraint(equalTo: arrowStack.heightAnchor, multiplier: 0.5),
            arrowDownLabel.heightAnchor.constraint(equalTo: arrowStack.heightAnchor, multiplier: 0.5)
        ])
        
        stack.addArrangedSubview(dayValueLabel)
        stack.addArrangedSubview(dayBeforeLabel)
        
        dayBeforeLabel.translatesAutoresizingMaskIntoConstraints = false
        dayValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStack.addArrangedSubview(stack)
        horizontalStack.addArrangedSubview(arrowStack)
        horizontalStack.addArrangedSubview(buyBlockView)

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

