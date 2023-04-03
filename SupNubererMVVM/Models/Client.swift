//
//  Client.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 31.03.23.
//

import Foundation
import CoreData

struct Client {
    
    let name: String?
    let inputNumber: String?
    let convertedNumber: String?
    
}

public class SingletoneArrayOfClients {
    
    static let shared = SingletoneArrayOfClients()
    
    var listOfClients: [NSManagedObject] = []{
        didSet{
            print(listOfClients.count)
        }
    }
}
