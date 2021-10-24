//
//  UILabel + Extension .swift
//  StocksKeeperMVVM
//
//  Created by dev on 21.10.21.
//

import UIKit

class MyLabel: UILabel {
    
    init(withFont font: UIFont?, color: UIColor, andText text: String?) {
        super.init(frame: .zero)
        self.font = font ?? UIFont.robotoMedium(withSize: 20)
        self.textColor = color
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
