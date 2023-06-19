//
//  MyCartTableViewCell.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 15/6/23.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
  func cartTableViewCell(_ cartTableViewCell: MyCartTableViewCell, itenCount counter: Int)
}

class MyCartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitlelbl: UILabel!
    @IBOutlet weak var regularPricelbl: UILabel!
    @IBOutlet weak var discountPricelbl: UILabel!
    @IBOutlet weak var brandlbl: UILabel!
    
    @IBOutlet weak var decramentButtonView: UIButton!
    @IBOutlet weak var incrementButtonView: UIButton!
    @IBOutlet weak var quantitylbl: UILabel!
    
    var quantity: Int = 1
    weak var cartDelegate: CartTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func decrementButtonPressed(_ sender: UIButton) {
        cartDelegate?.cartTableViewCell(self, itenCount: quantity)
        if quantity > 1 {
            quantity = quantity - 1
            self.quantitylbl.text = String(describing: quantity)
        }
    }
    
    @IBAction func incrementButtonPressed(_ sender: UIButton) {
        if quantity >= 1 {
            quantity = quantity + 1
            self.quantitylbl.text = String(describing: quantity)
        }
    }
    
    func setupCartUI(cart: Cart) {
        productTitlelbl.text = cart.title
        discountPricelbl.text = String(cart.discountPercentage)
        regularPricelbl.text = String(cart.price)
        discountPricelbl.text = String(cart.price * cart.discountPercentage * 100)
        brandlbl.text = cart.brand
        quantitylbl.text = String(cart.quantity)
        guard let url = URL(string: cart.thumbnail!) else { return }
        productImageView.loadImage(from: url)
    }
    
}
