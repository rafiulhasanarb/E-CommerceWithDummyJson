//
//  ResponseModel.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 9/6/23.
//

import Foundation

// MARK: - ResponseModel
struct ResponseModel: Codable {
    let response: [Response]
}

// MARK: - Response
struct Response: Codable {
    let category: String
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case category
        case products
    }
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, description: String
    let price: Int
    let discountPercentage, rating: Double
    let stock: Int
    let brand, category: String
    let thumbnail: String
    let images: [String]
}

// MARK: - Product
struct CartModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let quantity: Int
    let discountPercentage: Double
    let brand: String
    let category: String
    let thumbnail: String
}
