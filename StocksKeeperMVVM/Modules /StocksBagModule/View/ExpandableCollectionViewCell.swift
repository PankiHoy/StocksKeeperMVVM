//
//  ExpandableCollectionViewCell.swift
//  StocksKeeperMVVM
//
//  Created by dev on 20.10.21.
//

import UIKit

class ExpandableCollectionViewCell: UICollectionViewCell {
    static let identifier = "stocksCell"
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private var expandedConstaint: NSLayoutConstraint!
    private var collapsedConstraint: NSLayoutConstraint!
    
    private lazy var mainContainer = UIView()
    private lazy var topContainer = UIView()
    private lazy var bottomContainer = UIView()
    
    private lazy var arrowImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "arrow_down")!.withRenderingMode(.alwaysTemplate))
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        mainContainer.clipsToBounds = true
        topContainer.backgroundColor = .systemYellow
        bottomContainer.backgroundColor = .systemBlue
        
        makeConstraints()
        updateAppearance()
        
        configureUI()
    }
    
    private func configureUI() {
        mainContainer.clipsToBounds = true
        
        contentView.layer.cornerRadius = 20
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: self.layer.cornerRadius, height: self.layer.cornerRadius)).cgPath
    }
    
    private func updateAppearance() {
        collapsedConstraint.isActive = !isSelected
        expandedConstaint.isActive = isSelected
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999)
            self?.arrowImageView.transform = self?.isSelected ?? false ? upsideDown : .identity
        })
    }
    
    func makeConstraints() {
        contentView.addSubview(mainContainer)
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: topAnchor),
            mainContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        mainContainer.addSubview(topContainer)
        mainContainer.addSubview(bottomContainer)
        
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            bottomContainer.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            bottomContainer.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        collapsedConstraint = topContainer.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        collapsedConstraint.priority = .defaultLow
        
        expandedConstaint = bottomContainer.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        expandedConstaint.priority = .defaultLow
        
        topContainer.addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            arrowImageView.widthAnchor.constraint(equalToConstant: 24),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16),
            arrowImageView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -20)
        ])
        
    }
    
}
