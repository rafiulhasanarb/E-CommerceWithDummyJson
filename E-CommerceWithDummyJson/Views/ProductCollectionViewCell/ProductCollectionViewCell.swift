//
//  ProductCollectionViewCell.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 9/6/23.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    //MARK: outlets
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
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.4
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.backgroundColor = UIColor.systemRed.cgColor
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

extension UIImageView {
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let newImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.image = newImage
            }
        }
        task.resume()
    }
}
