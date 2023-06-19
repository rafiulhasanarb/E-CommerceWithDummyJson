//
//  CategoryCollectionViewCell.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 10/6/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryNamelbl: UILabel!
    @IBOutlet weak var countlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
    }
}
