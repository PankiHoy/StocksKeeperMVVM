//
//  AddBagViewController.swift
//  StocksKeeperMVVM
//
//  Created by dev on 17.10.21.
//

import UIKit

class AddBagView: UIView {
    weak var delegate: BagViewController?
    
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
        stackView.spacing = 20
        
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
        stackView.addArrangedSubview(addButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            
            nameTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            themeLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            themeLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            themeLabel.heightAnchor.constraint(equalToConstant: 50),
            
            addButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func chooseThemeAction(sender: UITapGestureRecognizer) {
        let label = sender.view
        let image = label?.subviews.first
        
        UIView.animate(withDuration: 0.2, animations: {
            image?.transform = CGAffineTransform(rotationAngle: .pi/2)
        })
    }
    
    @objc func createBag(sender: UIButton) {
        guard let nameTextFieldText = nameTextField.text else { return }
        delegate?.createBag(sender: sender, name: nameTextFieldText)
    }
}
