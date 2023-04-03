//
//  ViewModel.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 31.03.23.
//

import Foundation
import UIKit
import CoreData

class ViewModel{
    
    var whatsThat = Dynamic("")
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context: NSManagedObjectContext!
    
    func convertBtnPressed(number: String, name: String) {
        
        let unsafeChars = CharacterSet.alphanumerics.inverted
        let lowLetters = CharacterSet.lowercaseLetters
        let uppLetters = CharacterSet.uppercaseLetters
        
        let cleanChars  = number.components(separatedBy: unsafeChars).joined(separator: "")
        let cleanLowLett = cleanChars.components(separatedBy: lowLetters).joined(separator: "")
        let cleanUppLett = cleanLowLett.components(separatedBy: uppLetters).joined(separator: "")
        
        let dropFirst = String(cleanUppLett.dropFirst(3))
        let result = "**80\(dropFirst)"
        
        let tempClient = Client(name: name, inputNumber: number, convertedNumber: result)
        
        whatsThat.value = result
        //saveClientToCoreData(client: tempClient)
        //SingletoneArrayOfClients.shared.listOfClients.append(tempClient)
        //updateSingletoneClientsArray(client: tempClient)
        checkCoreDataForEmpty(client: tempClient)
        whereIsMySQLite()
        
    }
    
    func coreDataToSingletoneArr() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "ClientEntity")
        
        //3
        do {
            SingletoneArrayOfClients.shared.listOfClients = try managedContext.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func checkCoreDataForEmpty(client: Client){
        
        coreDataToSingletoneArr()
        
        if SingletoneArrayOfClients.shared.listOfClients.isEmpty {
            saveClientToCoreData(client: client)
        } else {
            checkBeforeUpdate(client: client)
        }
        
    }
    
    func saveClientToCoreData(client: Client) {
        
        
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ClientEntity", in: context)
        
        
        let newClient = NSManagedObject(entity: entity!, insertInto: context)
        newClient.setValue(client.name, forKey: "name")
        newClient.setValue(client.convertedNumber, forKey: "number")
        newClient.setValue(getDate(), forKey: "lastCall")
        
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ClientEntity")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                _ = data.value(forKey: "name") as! String
                _ = data.value(forKey: "number") as! String
                _ = data.value(forKey: "lastCall") as? Date
                
            }
            
        } catch {
            print("Fetching data Failed")
        }
    }
    
    func checkBeforeUpdate(client: Client) {
        
        var isRefreshNeccessery = false
        
        coreDataToSingletoneArr()
        
        for arrayClient in SingletoneArrayOfClients.shared.listOfClients {
            if arrayClient.value(forKey: "number") as! String == client.convertedNumber {
                
                print("numbers equal")
                isRefreshNeccessery = false
                break
            } else {
                isRefreshNeccessery = true
                print("match not found")
            }
        }
        
        if isRefreshNeccessery == true {
            
            print("updating core data")
            saveClientToCoreData(client: client)
        } else {
            print("no need to refresh array")
        }
    }
    
    func getDate() -> Date {
        
        let date = Date()
        return date
    }
    
    func whereIsMySQLite() {
        let path = NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print(path ?? "Not found")
    }
    
    
}
