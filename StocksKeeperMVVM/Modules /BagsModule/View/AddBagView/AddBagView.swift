//
//  AddBagViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 17.10.21.
//

import UIKit

class AddBagView: UIView {
    weak var delegate: BagViewController?
    
    static let rsGreen = UIColor(named: "rsGreen")
    static let rsLightBlue = UIColor(named: "rsLightBlue")
    static let rsOrange = UIColor(named: "rsOrange")
    static let rsPink = UIColor(named: "rsPink")
    static let rsPurple = UIColor(named: "rsPurple")
    static let rsRed = UIColor(named: "rsRed")
    static let rsYellow = UIColor(named: "rsYellow")
    
    let colors = [
        UIColor.rsGreen,
        UIColor.rsLightBlue,
        UIColor.rsOrange,
        UIColor.rsPink,
        UIColor.rsPurple,
        UIColor.rsRed,
        UIColor.rsYellow,
    ]
    
    lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .white
        view.isHidden = true
        
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        
        return view
    }()
    
    let nameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Bag Name"
        view.font = UIFont.robotoItalic(withSize: 24)
        view.textColor = .black
        view.tintColor = .black
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        configureColorCollcetionView()
        configureLabels()
    }
    
    func configureLabels() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 200),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 40),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -40),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -200)
        ])
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "CREATE NEW BAG"
        titleLabel.font = UIFont.robotoBold(withSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        nameTextField.becomeFirstResponder()
        
        let themeLabel = UILabel()
        themeLabel.text = "Choose theme"
        themeLabel.font = UIFont.robotoItalic(withSize: 24)
        themeLabel.textColor = .black
        
        themeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseThemeAction(sender:))))
        themeLabel.isUserInteractionEnabled = true
        
        let arrowImage = UIImageView(image: UIImage(systemName: "arrowtriangle.forward"))
        arrowImage.tintColor = .black
        
        themeLabel.addSubview(arrowImage)
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            arrowImage.centerYAnchor.constraint(equalTo: themeLabel.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: themeLabel.trailingAnchor, constant: -5)
        ])
        
        let addButton = UIButton()
        addButton.setTitle("ADD BAG", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.robotoMedium(withSize: 24)
        addButton.addTarget(self, action: #selector(createBag(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(themeLabel)
        stackView.addArrangedSubview(colorCollectionView)
        stackView.addArrangedSubview(addButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            
            nameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            themeLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            themeLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            themeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            colorCollectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            colorCollectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 20),
            
            addButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -20),
        ])
    }
    
    func configureColorCollcetionView() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")

        addSubview(colorCollectionView)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func chooseThemeAction(sender: UITapGestureRecognizer) {
        let label = sender.view
        let image = label?.subviews.first
        
        UIView.animate(withDuration: 0.2, animations: {
            image?.transform = CGAffineTransform(rotationAngle: .pi/2)
        })
        
        colorCollectionView.isHidden = false
    }
    
    @objc func createBag(sender: UIButton) {
        guard let nameTextFieldText = nameTextField.text else { return }
        delegate?.createBag(sender: sender, name: nameTextFieldText)
    }
}

extension AddBagView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let totalCellWidth = 20 * (colors.count-1)
//        let totalSpacingWidth = 5 * (colors.count-1-1)
//
//        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
}

extension AddBagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        cell.layer.cornerRadius = 10
        
        return cell
    }
}
