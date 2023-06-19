//
//  ProductTableViewCell.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 10/6/23.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productBackgroundView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(product: Product) {
        productTitleLabel.text = product.title
        stockLabel.text = "Stock: \(product.stock)"
        priceLabel.text = "Price: $\(product.price)"
        discountPriceLabel.text = "Off: \(product.discountPercentage)%"
        rateButton.setTitle("\(product.rating)", for: .normal)
        guard let url = URL(string: product.thumbnail) else { return }
        productImageView.loadImage(from: url)
    }
}
