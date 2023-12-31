//
//  CartTableViewCell.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 11/6/23.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var quantity: Int = 1
    var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        incrementButton.layer.cornerRadius = 10
        incrementButton.clipsToBounds = true
        decrementButton.layer.cornerRadius = 10
        decrementButton.clipsToBounds = true
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func updateCartItemQuantity(_ sender: Any) {
        if (sender as! UIButton).tag == 0 {
            quantity = quantity + 1
        } else if quantity > 0 {
            quantity = quantity - 1
        }
        
//        decrementButton.isEnabled = quantity > 0
//        decrementButton.backgroundColor = !decrementButton.isEnabled ? .gray : .black
//        self.quantityLabel.text = String(describing: quantity)
//        Cart.updateCart(withProduct: product, forQuantity: quantity)
    }
    
    func configureCell(withCart cart:Cart){
        if let product = product {
            self.product = product
            nameLabel.text = product.title
            priceLabel.text = "$ \(cart.price)"
            quantityLabel.text = String(describing: cart.quantity)
            quantity = Int(cart.quantity)
        }
    }
}
