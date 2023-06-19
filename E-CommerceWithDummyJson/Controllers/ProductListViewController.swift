//
//  ProductListViewController.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 9/6/23.
//

import UIKit

class ProductListViewController: UIViewController {

    //MARK: outlets
    @IBOutlet weak var productTableview: UITableView!
    
    // MARK: - Variables
    var productData: ResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableview.dataSource = self
        productTableview.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")

        // Do any additional setup after loading the view.
        loadJson()
    }

    func loadJson() {
        guard let path = Bundle.main.path(forResource: "dummyJson", ofType: "json") else { return }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            let jsonData = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let convertedData = try jsonDecoder.decode(ResponseModel.self, from: jsonData)
            productData = convertedData
        } catch {
            print(error)
        }
    }
    
    func moveProductListing(index: Int) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as? ProductsViewController else { return }
        vc.productsListing = productData?.response[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveProductDetails(tableIndex: Int, cellIndex: Int) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ProductsDetailsViewController") as? ProductsDetailsViewController else { return }
        vc.product = productData?.response[tableIndex].products[cellIndex]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productData?.response.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.products = productData?.response[indexPath.row]
        
        cell.index = indexPath.row
        cell.onClickSeeAllClosure = { index in
            if let index = index {
                self.moveProductListing(index: index)
            }
        }
        
        cell.didSelectClosure = { tableIndex, cellIndex in
            if let tableIndex = tableIndex, let cellIndex = cellIndex {
                self.moveProductDetails(tableIndex: tableIndex, cellIndex: cellIndex)
            }
        }
        
        return cell
    }    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 306
    }
}
