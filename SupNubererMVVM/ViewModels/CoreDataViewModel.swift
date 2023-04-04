//
//  CoreDataViewModel.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 4.04.23.
//

import Foundation
import CoreData
import UIKit

class CoreDataViewModel {
    
    let container: NSPersistentContainer
    var savedEntities: [ClientEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "SupNubererMVVM")
        container.loadPersistentStores { (description, error) in
            
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            } else {
                print("Successfully loaded core data!")
            }
            
        }
            //print path to core data sql file
            let path = NSPersistentContainer
                .defaultDirectoryURL()
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding
            
            print(path ?? "Not found")
    }
    
    func fetchClients() {
        let request = NSFetchRequest<ClientEntity>(entityName: "ClientEntity")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
        
    }
    
    func addClient(client: Client) {
        let newClient = ClientEntity(context: container.viewContext)
        newClient.number = client.convertedNumber
        newClient.name = client.name
        newClient.lastCall = Date()
        
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    
    func clearDatabase() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        guard let url = appDelegate.persistentContainer.persistentStoreDescriptions.first?.url else { return }
        
        let persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator

         do {
             try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
             try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
             print("db cleared")
         } catch {
             print("Attempted to clear persistent store: " + error.localizedDescription)
         }
    }
    
}
