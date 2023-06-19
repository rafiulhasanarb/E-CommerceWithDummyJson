//
//  ProductsViewController.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 10/6/23.
//

import UIKit

class ProductsViewController: UIViewController {
    //MARK: outlets
    @IBOutlet weak var productsTableview: UITableView!
    
    //MARK: variables
    var productsListing: Response?
    let pageLimit = 20
    var currentLastId: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableview.dataSource = self
        productsTableview.delegate = self
        productsTableview.estimatedRowHeight = 120
        productsTableview.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        // Do any additional setup after loading the view.
    }
}

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsListing?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let product = productsListing?.products[indexPath.row]
        cell.setupUI(product: product!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
}

extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ProductsDetailsViewController") as! ProductsDetailsViewController
        vc.product = productsListing?.products[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard (self.productsListing?.products.isEmpty == nil) else { return }
        
    }
    
    private func hideBottomLoader() {
        DispatchQueue.main.async {
            let lastListIndexPath = IndexPath(row: (self.productsListing?.products.count)! - 1, section: 1)
            self.productsTableview.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
        }
    }
}
