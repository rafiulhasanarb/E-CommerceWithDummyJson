//
//  CartViewController.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 9/6/23.
//

import UIKit
import CoreData

class CartViewController: UIViewController {
    
    //MARK: outlets
    @IBOutlet weak var carttableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var cartProduct: [Cart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        carttableView.dataSource = self
        carttableView.delegate = self
        carttableView.estimatedRowHeight = 100
        carttableView.register(UINib(nibName: "MyCartTableViewCell", bundle: nil), forCellReuseIdentifier: "MyCartTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.cartProduct.removeAll()
        self.fetchProducts()
        self.carttableView.reloadData()
        self.totalLabel.text = String(calculateCartTotal())
    }
    
    private func fetchProducts() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        debugPrint(path[0])
        
        do {
            guard let result = try PersistentStorage.shared.context.fetch(Cart.fetchRequest()) as? [Cart] else { return }
            result.forEach { cart in
                cartProduct.append(cart)
            }
        } catch let error {
            debugPrint(error)
        }
    }
    
    private func deleteProduct(id: Int64) -> Bool {
        let cart = getCart(byId: id)
        guard cart != nil else {return false}
        
        PersistentStorage.shared.context.delete(cart!)
        PersistentStorage.shared.saveContext()
        return true
    }
    
    private func getCart(byId id: Int64) -> Cart? {
        let fetchRequest = NSFetchRequest<Cart>(entityName: "Cart")
        let fetchById = NSPredicate(format: "id==%id", id as CVarArg)
        fetchRequest.predicate = fetchById
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            guard result != nil else {return nil}
            return result
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func cartTableViewCell(_ cartTableViewCell: MyCartTableViewCell, itenCount counter: Int) {
        let newCount = counter + 1
    }
    
    func calculateCartTotal() -> Double {
        var total = 0.0
        if self.cartProduct.count > 0 {
            for index in 0...self.cartProduct.count - 1 {
                total += cartProduct[index].price
            }
        }
        return total
    }
    
    func loadImage(_ imageURL: String) -> UIImage {
        var image: UIImage!
        if let url = NSURL(string: imageURL) {
            if let data = NSData(contentsOf: url as URL) {
                image = UIImage(data: data as Data)
            }
        }
        return image!
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cartProduct.count)
        return cartProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCartTableViewCell", for: indexPath) as! MyCartTableViewCell
        let cart = cartProduct[indexPath.row]
        cell.setupCartUI(cart: cart)
        cell.cartDelegate = self
        return cell
    }
}

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return  true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let success = deleteProduct(id: self.cartProduct[indexPath.row].id)
            if success {
                self.cartProduct.removeAll()
                self.fetchProducts()
                self.carttableView.reloadData()
            }
        }
        //tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductsDetailsViewController") as! ProductsDetailsViewController
        //vc.product = cartProduct[indexPath.row]
        navigationController?.present(vc, animated: true)
    }
}
