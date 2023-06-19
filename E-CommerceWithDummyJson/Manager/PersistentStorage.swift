//
//  PersistentStorage.swift
//  E-CommerceWithDummyJson
//
//  Created by rafiul hasan on 15/6/23.
//

import CoreData
import Foundation

final class PersistentStorage {
    
    private init(){}
    static let shared = PersistentStorage()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "E-Commerce")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchManagedObject<T: NSManagedObject>(manageObject: T.Type) -> [T]? {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(manageObject.fetchRequest()) as? [T] else { return nil}
            return result
        } catch let error{
            debugPrint(error)
        }
        return nil
    }
    
    func printDocumentDirectoryPath() {
        debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
}

struct CartManager {
    func createCart(cart: Cart) {
        // create employee code here
    }

    func fetchEmployee() -> [Cart]? {
        // fetch employee code here
        return nil
    }

    func updateEmployee(cart: Cart) -> Bool {
        // update employee code here
        return false
    }

    func deleteEmployee(id: Int64) -> Bool {
        // delete employee code here
        return false
    }
}

struct CartDataRepository {
    func create(cart: Cart) {
        let cdCart = Cart(context: PersistentStorage.shared.context)
        cdCart.title = cart.title
        cdCart.price = cart.price
        cdCart.id = cart.id

        PersistentStorage.shared.saveContext()
    }

    func getAll() -> [Cart]? {
        let result = PersistentStorage.shared.fetchManagedObject(manageObject: Cart.self)
        var cart : [Cart] = []
        result?.forEach({ (cdCart) in
            cart.append(cdCart)
        })
        return cart
    }

    func get(byIdentifier id: Int64) -> Cart? {
        let fetchRequest = NSFetchRequest<Cart>(entityName: "Cart")
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first
            guard result != nil else {return nil}
            return result
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
    
    private func getCart(byId id: Int64) -> Cart? {
        let fetchRequest = NSFetchRequest<Cart>(entityName: "Cart")
        let fetchById = NSPredicate(format: "id==%@", id as CVarArg)
        fetchRequest.predicate = fetchById
        
        let result = try! PersistentStorage.shared.context.fetch(fetchRequest)
        guard result.count != 0 else {return nil}
        return result.first
    }

    func update(cart: Cart, subTotal: Double?, quantity: Int16) {
        let context = PersistentStorage.shared.context
        let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == \(fetchRequest)")
        do {
            let result = try context.fetch(fetchRequest)
            if let cart = result.first{
                if quantity == 0 {
                    context.delete(cart)
                }else{
                    cart.quantity = quantity
                    cart.subTotal = (cart.price * Double(cart.quantity))
                }
            }
            PersistentStorage.shared.saveContext()
        } catch {
            print("Could not fetch cart")
        }
    }

    func delete(id: Int64) -> Bool {
        let cart = getCart(byId: id)
        guard cart != nil else {return false}
        
        PersistentStorage.shared.context.delete(cart!)
        PersistentStorage.shared.saveContext()
        return true
    }
}
