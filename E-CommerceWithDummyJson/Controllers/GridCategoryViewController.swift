//
//  GridCategoryViewController.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 9/6/23.
//

import UIKit

class GridCategoryViewController: UIViewController {

    //MARK: outlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    //MARK: variables
    var productData: ResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
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
}

extension GridCategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productData?.response.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryView.backgroundColor = randomColor()
        cell.categoryNamelbl.text = productData?.response[indexPath.row].category.capitalized
        cell.countlbl.text = "Stock: \(productData?.response[indexPath.row].products.count ?? 0)"
        return cell
    }
    
    func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func randomColor() -> UIColor {
        let r = randomCGFloat()
        let g = randomCGFloat()
        let b = randomCGFloat()
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}

extension GridCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        vc.productsListing = productData?.response[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GridCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let deviceWidth = collectionView.frame.width
        return CGSize(width: (deviceWidth/3) - 8, height: 100)
    }
}
