//
//  DetailedControllerView + Extension.swift
//  StocksKeeperMVVM
//
//  Created by dev on 10.10.21.
//

import UIKit

extension DetailedControllerView {
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
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
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
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -50)
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
        bookMarkLabel.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookMarkLabel.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        
        bookMarkLabel.isSelected = bookmarked ?? false
        
        bookMarkLabel.addTarget(self, action: #selector(addBookMark(sender:)), for: .touchUpInside)
        bookMarkLabel.isSelected = false
        
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
        
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 50).isActive = true
        
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
        
        stack.addArrangedSubview(dayValueLabel)
        stack.addArrangedSubview(dayBeforeLabel)
        
        dayBeforeLabel.translatesAutoresizingMaskIntoConstraints = false
        dayValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayBeforeLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: UIScreen.main.bounds.width/4),
            dayValueLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: UIScreen.main.bounds.width/4),
        ])
        
        let randomLabel = UIButton()
        randomLabel.setTitle("BUY", for: .normal)
        randomLabel.titleLabel?.textAlignment = .center
        randomLabel.titleLabel?.numberOfLines = 0
        randomLabel.titleLabel?.font = UIFont.robotoMedium(withSize: 25)
        randomLabel.setTitleColor(.black, for: .normal)
        
        randomLabel.addTarget(self, action: #selector(buyStock(sender:amount:)), for: .touchUpInside)
        
        horizontalStack.addArrangedSubview(stack)
        horizontalStack.addArrangedSubview(randomLabel)
        
        return horizontalStack
    }
    
    @objc func addBookMark(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            saveStock()
        } else {
            sender.isSelected = false
        }
    }
    
    func saveStock() {
        guard let user = self.delegate.viewModel?.add(type: Stock.self) else { return }
        guard let company = company else { return }
        user.name = company.name
        user.desctiption = company.description
        user.symbol = company.symbol
        user.day = company.day
        user.dayBefore = company.dayBefore
        user.bookmarked = true
        delegate.viewModel?.save()
    }
    
    @objc func buyStock(sender: UITapGestureRecognizer, amount: Int) {
        dump("buy \(amount) stocks")
    }
    
}

