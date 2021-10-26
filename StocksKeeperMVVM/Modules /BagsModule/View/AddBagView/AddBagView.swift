//
//  AddBagViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 17.10.21.
//

import UIKit
import SnapKit

class AddBagView: UIView {
    weak var delegate: BagViewController?
    
    let colors = [
        UIColor.rsGreen,
        UIColor.rsLightBlue,
        UIColor.rsOrange,
        UIColor.rsPink,
        UIColor.rsRed,
        UIColor.rsYellow,
    ]
    
    lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        
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
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(275)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-75)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "CREATE NEW BAG"
        titleLabel.font = UIFont.robotoBold(withSize: 24)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        
        let themeLabel = UILabel()
        themeLabel.text = "Choose theme"
        themeLabel.font = UIFont.robotoItalic(withSize: 24)
        themeLabel.textColor = .black
        
        let arrowImage = UIImageView(image: UIImage(systemName: "arrowtriangle.down"))
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
        
        let colorCollectionViewView = UIView()
        colorCollectionViewView.addSubview(colorCollectionView)
        
        colorCollectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        contentView.addSubview(colorCollectionViewView)
        contentView.addSubview(addButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(12.5)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        themeLabel.snp.makeConstraints { make in
            make.height.equalTo(35)
        }
        
        colorCollectionViewView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-65)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12.5)
        }
    }
    
    func configureColorCollcetionView() {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        colorCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
    }
    
    @objc func createBag(sender: UIButton) {
        guard let nameTextFieldText = nameTextField.text else { return }
        delegate?.createBag(sender: sender, name: nameTextFieldText)
    }
}

extension AddBagView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddBagView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = 40 * (colors.count+1)
        let totalSpacingWidth = 5 * (colors.count-1-1)

        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 2, left: leftInset, bottom: 2, right: rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellSubview = collectionView.cellForItem(at: indexPath)?.subviews.first
        UIView.animate(withDuration: 0.2, animations: {
            cellSubview?.frame = CGRect(x: 2, y: 2, width: 36, height: 36)
            cellSubview?.layer.cornerRadius = 8
            self.contentView.backgroundColor = cellSubview?.backgroundColor
        })
    }
}

extension AddBagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell
        cell?.configureCell(withColor: colors[indexPath.row]!)
        
        return cell!
    }
}
