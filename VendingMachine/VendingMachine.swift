//
//  VendingMachine.swift
//  VendingMachine
//
//  Created by Hsin An Hsu on 8/2/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import Foundation
import UIKit

protocol VendingMachineType {
    var selection: [VendingSelection] { get }
    var inventory: [VendingSelection : ItemType] { get set }
    var amountDeposited: Double { get set }
    
    init(inventory: [VendingSelection : ItemType])
    func vend(selection: VendingSelection, quantity: Double) throws
    func deposit(amount: Double)
    func itemForCurrentSelection(selection: VendingSelection) -> ItemType?
}

protocol ItemType {
    var price: Double { get }
    var quantity: Double { get set }
}


//MARK: Error Tpyes
enum InventoryError: ErrorType {
    case InvalidResource
    case ConversionError
    case invalidKey
}

enum VendingMachineError: ErrorType {
    case InvalidSelection
    case OutOfStock
    case InsufficientFunds(requireed: Double) // let user know need how many money
    
    
}
//MARK: Helper Classes
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

//MARK: Concrete Types

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
    
    func icon() -> UIImage {
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            return UIImage(named:"Default")!
        }
        
    }
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
        /*when user make selection we have to make sure that: 1. selection is a valid one. 2. we have enough in stock so we have to check inventory quantity. 3. the usre has enough cash to buy the item. */
        
        //1
        guard var item = inventory[selection] else {
            throw VendingMachineError.InvalidSelection
        }
        //2
        guard item.quantity > 0 else {
            throw VendingMachineError.OutOfStock
        }
        
        item.quantity -= quantity
        inventory.updateValue(item, forKey: selection)
        
        //3
        let totalPrice = item.price * quantity
        
        
        if amountDeposited >= totalPrice {
            amountDeposited -= totalPrice
        } else {
            let amountRequred = totalPrice - amountDeposited
            throw VendingMachineError.InsufficientFunds(requireed: amountRequred)
        }
        
    }
    
    func itemForCurrentSelection(selection: VendingSelection) -> ItemType? {
        return inventory[selection]
    }
    
    func deposit(amount: Double) {
        amountDeposited += amount
    }
    
}



