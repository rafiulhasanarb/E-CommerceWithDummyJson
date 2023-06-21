//
//  ProductsDetailsViewController.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 10/6/23.
//

import UIKit
import CoreData

class ProductsDetailsViewController: UIViewController {
    
    //MARK: outlets
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var productTitlelbl: UILabel!
    @IBOutlet weak var productDescriplbl: UILabel!
    @IBOutlet weak var ratingButtonView: UIButton!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var discountlbl: UILabel!
    @IBOutlet weak var afterDiscountlbl: UILabel!
    @IBOutlet weak var savelbl: UILabel!
    @IBOutlet weak var brandlbl: UILabel!
    @IBOutlet weak var categorylbl: UILabel!
    @IBOutlet weak var stocklbl: UILabel!
    
    //MARK: variables
    var product: Product!
    var imageName: [String] = []
    var timer = Timer()
    var counter = 0
    var count : Int = 0
    var quantity: Int = 1
    var addTocart: [Cart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sliderCollectionView.dataSource = self
        sliderCollectionView.delegate = self
        sliderCollectionView.register(UINib(nibName: "SliderImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SliderImageCollectionViewCell")
        self.setupUI(product: self.product)
        self.pageController()
        print(product!)
    }
    
    func pageController() {
        pageView.numberOfPages = self.imageName.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    func setupUI(product: Product) {
        title = product.title
        productTitlelbl.text = product.title
        productDescriplbl.text = product.description
        ratingButtonView.setTitle("\(product.rating)", for: .normal)
        pricelbl.text = "Regular Price: $\(product.price)"
        discountlbl.text = "Discount: \(product.discountPercentage)%"
        let discontPrice = Double(product.price) - ((Double(product.price) * product.discountPercentage) / 100)
        let rounded = round(discontPrice * 100) / 100.0
        afterDiscountlbl.text = "After Discount: $ \(rounded)"
        let saveAmount = (Double(product.price) * product.discountPercentage) / 100
        let saveRounded = round(saveAmount * 100) / 100.0
        savelbl.text = "Save: $\(saveRounded)"
        brandlbl.text = "Brand: \(product.brand)"
        categorylbl.text = "Category: \(product.category)"
        stocklbl.text = "Stock: \(product.stock)"
        
        for image in product.images {
            self.imageName.append(image)
        }
    }
    
    @objc func changeImage() {
        if counter < self.imageName.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }
    
    @IBAction func addToCartPressed(_ sender: UIButton) {
        if product != nil {
            self.addToCart(product: self.product, quantity: 1, totalPrice: 12.0)
            let alertController = UIAlertController(title: "Success", message: "Successfully add to cart. Go to cart page to buy.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        } else {
            
        }
    }
    
    @IBAction func buyNowPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Buy Now", message: "Confirm to Buy Now", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }

}

extension ProductsDetailsViewController {
    
    func loadImage(_ imageURL: String) -> UIImage {
        var image: UIImage!
        if let url = NSURL(string: imageURL) {
            if let data = NSData(contentsOf: url as URL) {
                image = UIImage(data: data as Data)
            }
        }
        return image!
    }
    
    func addToCart(product: Product, quantity: Double, totalPrice: Double) {
        let managedContext = PersistentStorage.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Cart", in: managedContext)
        let productToAdd = NSManagedObject(entity: entity!, insertInto: managedContext)
        productToAdd.setValue(product.title, forKeyPath: "title")
        productToAdd.setValue(product.price, forKeyPath: "price")
        productToAdd.setValue(quantity, forKeyPath: "quantity")
        productToAdd.setValue(product.id, forKeyPath: "id")
        productToAdd.setValue(product.brand, forKeyPath: "brand")
        productToAdd.setValue(product.category, forKeyPath: "category")
        productToAdd.setValue(product.thumbnail, forKeyPath: "thumbnail")
        
        do {
            try managedContext.save()
            print("Successfully added on cart")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

//MARK: for Datasource
extension ProductsDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderImageCollectionViewCell", for: indexPath) as! SliderImageCollectionViewCell
        let url = URL(string: imageName[indexPath.item])!
        cell.sliderImageView.loadImage(from: url)
        return cell
    }
}

//MARK: for FlowLayout
extension ProductsDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        return CGSize(width: bounds.width, height: bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
