//
//  main.swift
//  L7_ilyasleptsov
//
//  Created by Илья Слепцов on 25.03.2021.
//

import Foundation

//MARK: - Task 1
// 1. Придумать класс, методы которого могут завершаться неудачей и возвращать либо значение, либо ошибку Error?. Реализовать их вызов и обработать результат метода при помощи конструкции if let, или guard let.



struct Lenses {
    let name: String
}

struct Item {
    var price: Int
    var count: Int
    var diopters: Double
    var product: Lenses
}

class VendingWithLenses {
    
    var positionsInVending = [
        "Acuvue": Item(price: 1300, count: 5, diopters: -2.0, product: Lenses(name: "Acuvue")),
        "Alcon": Item(price: 1100, count: 0, diopters: -2.0, product: Lenses(name: "Alcon")),
        "BioTrue": Item(price: 900, count: 5, diopters: -2.0, product: Lenses(name: "BioTrue"))
    ]
    
    var coinsDeposite = 5000
    
    func vend(itemNamed name: String) -> Lenses? {
        
        guard let item = positionsInVending[name] else {
            return nil
        }
        
        guard item.count > 0 else {
            return nil
        }
        
        guard item.price <= coinsDeposite else {
            return nil
        }
        
        
        coinsDeposite -= item.price
        
        var newItem = item
        newItem.count -= 1
        
        positionsInVending[name] = newItem
        print("Выдача \(name)")
        return newItem.product
    }
}

let vendingWithLenses = VendingWithLenses()
vendingWithLenses.vend(itemNamed: "Acuvue")
vendingWithLenses.vend(itemNamed: "Alcon")
vendingWithLenses.vend(itemNamed: "BioTrue")

enum VendingWithLensesEror: Error {
    case invalidSelection
    case outOfStocks
    case insufficientFunds(coinsNeded: Int)
    
    var localizedDescription: String {
        switch self {
        case .invalidSelection:
            return "Нет в ассортименте"
        case .outOfStocks:
            return "Нет в наличии"
        case .insufficientFunds(coinsNeded: let coinsNeeded):
            return "Недостаточно денег: \(coinsNeeded)"
        }
    }
}

extension VendingWithLenses {
    
    func vendWithEror(itemName name: String) -> (product: Lenses?, error: VendingWithLensesEror?) {
        guard let item = positionsInVending[name] else {
            return (product: nil, error: .invalidSelection)
        }
        guard coinsDeposite >= item.price else {
            return (product: nil, error: .insufficientFunds(coinsNeded: item.price - coinsDeposite))
        }
        guard item.count > 0 else {
            return (product: nil, error: .outOfStocks)
        }
        
        coinsDeposite -= item.price
        
        var newItem = item
        newItem.count -= 1
        positionsInVending[name] = newItem
        
        return (product: item.product, error: nil)
        
    }
}

let sale1 = vendingWithLenses.vendWithEror(itemName: "Acuvue")
if let product = sale1.product {
    print("Мы купили \(product.name)")
} else if let error = sale1.error {
    print("Произошла ошибка \(error.localizedDescription)")
}

let sale2 = vendingWithLenses.vendWithEror(itemName: "Alcon")
if let product = sale2.product {
    print("Мы купили \(product.name)")
} else if let error = sale2.error {
    print("Произошла ошибка \(error.localizedDescription)")
}

let sale3 = vendingWithLenses.vendWithEror(itemName: "BioTrue")

if let product = sale3.product {
    print("Мы купили \(product.name)")
} else if let error = sale3.error {
    print("Произошла ошибка \(error.localizedDescription)")
}


//MARK: - Task 2
// 2. Придумать класс, методы которого могут выбрасывать ошибки. Реализуйте несколько throws-функций. Вызовите их и обработайте результат вызова при помощи конструкции try/catch.


extension VendingWithLenses {
    
    func correctVend(itemNamed name: String) throws -> Lenses {
        guard let item = positionsInVending[name] else {
            throw VendingWithLensesEror.invalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingWithLensesEror.outOfStocks
        }
        
        guard item.price <= coinsDeposite else {
            throw VendingWithLensesEror.insufficientFunds(coinsNeded: item.price - coinsDeposite)
        }
        
        coinsDeposite -= item.price
        var newItem = item
        newItem.count -= 1
        positionsInVending[name] = newItem
        return newItem.product
    }
}

do {
    let someSell = try vendingWithLenses.correctVend(itemNamed: "Acuvue")
    print("Мы купили: \(someSell.name)")
} catch VendingWithLensesEror.invalidSelection {
    print("Такого товара не существует")
} catch VendingWithLensesEror.outOfStocks {
    print("Товар закончился")
} catch VendingWithLensesEror.insufficientFunds(let coinsNeeded) {
    print("Недостаточно денег, необходимо \(coinsNeeded) монет")
}
