//
//  Transactions.swift
//
//
//  Created by Alain Gabellier on 04/09/2018.
//

import UIKit
import RealmSwift

class Transaction : Object {
    
    // Properties
    @objc dynamic var date : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var amount : Float = 0.0
    @objc dynamic var reccurent : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    @objc dynamic var category : Categories = .vc
    @objc dynamic var account : Comptes = .axa
    
//    // Methods
//    func asDictionary() throws -> [String: Any] {
//        let data = try JSONEncoder().encode(self)
//        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
//            throw NSError()
//        }
//        return dictionary
//    }
}

class Categories: Object {
    @objc dynamic var name : String = ""
    let transactions = List<Transaction>()

}

class Comptes: Object {
    @objc dynamic var name : String = ""
    let transactions = List<Transaction>()
}
