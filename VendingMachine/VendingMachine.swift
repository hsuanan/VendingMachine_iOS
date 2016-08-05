//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Hsin An Hsu on 8/2/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation

protocol VendingMachineType {
    var selection: [VendingSelection] { get }
    var inventory: [VendingSelection : ItemType] { get set }
    var amountDeposited: Double { get set }
    
    init(inventory: [VendingSelection : ItemType])
    func vend(selection: VendingSelection, quantity: Double) throws
    func deposit(amount: Double)
}

protocol ItemType {
    var price: Double { get }
    var quantity: Double { get set }
}


//Error Tpyes
enum InventoryError: ErrorType {
    case InvalidResource
    case ConversionError
    case invalidKey
}
//Helper Classes
/*1. take a p list file as input and returns a dictionary as iptput
     errors may occur: file may not exist, file may be corrupted, or it may be empty
2. take a dictionary of arbitrary input and converts it to an inventory object that we need. */

/* 用class 因為要將dictionary or p list convert it to a dictionary and then convert it to an inventory, */




class PlistConverter {
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> [String:AnyObject] {
        
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw InventoryError.InvalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path),
            let castDictionary = dictionary as? [String: AnyObject] else {
            throw InventoryError.ConversionError
        }
        
        return castDictionary
    }
}

class InventoryUnarchiver {
    class func vendingInventoryFromDictionary(dictionary: [String: AnyObject]) throws -> [VendingSelection : ItemType] {
        
        var inventory: [VendingSelection : ItemType] = [:]
        
        for (key, value) in dictionary {
            if let itemDict = value as? [String : Double], let price = itemDict["price"], let quantity = itemDict["quantity"] {
            
                let item = VendingItem(price: price, quantity: quantity)
                
                guard let key = VendingSelection(rawValue: key) else {
                    throw InventoryError.invalidKey
                }
                
                inventory.updateValue(item, forKey: key)
            
            }
        }
        return inventory
    }
}

//Concrete Types

enum VendingSelection: String { // adding rawvalue
    case Soda
    case DietSoda
    case Chips
    case Cookie
    case Sandwich
    case Wrap
    case CandyBar
    case PopTart
    case Water
    case FruitJuice
    case SportsDrink
    case Gum
}

struct VendingItem: ItemType {
    var price: Double
    var quantity: Double

}

class VendingMachine: VendingMachineType {
    let selection: [VendingSelection] = [.Soda, .DietSoda, .Chips, .Cookie, .Sandwich, .Wrap, .CandyBar, .PopTart, .Water, .FruitJuice, .SportsDrink, .Gum]
    
    var inventory: [VendingSelection : ItemType]
    
    var amountDeposited: Double = 10.0
    
    required  init(inventory: [VendingSelection : ItemType]) {
        self.inventory = inventory
    }
    
    func vend(selection: VendingSelection, quantity: Double) throws {
        //add code
    }
    
    func deposit(amount: Double) {
        //add code
    }
    
}



