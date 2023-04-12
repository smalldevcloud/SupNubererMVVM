//
//  ViewModel.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 31.03.23.
//

import Foundation

class ViewModel{
    
    var dynamic = Dynamic("")
    var coreDataVM = CoreDataViewModel()
    
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
        
        dynamic.value = result

        coreDataVM.fetchClients()
        if isCoreDataEmpty() {
            coreDataVM.addClient(client: tempClient)
        } else {
            
            if isArrContainsThatNumber(newClient: tempClient) {

            } else {
                coreDataVM.addClient(client: tempClient)
            }
        }
    }
    
    func isCoreDataEmpty() -> Bool {
        
        if coreDataVM.savedEntities.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func isArrContainsThatNumber(newClient: Client) -> Bool {
        var isContains = false
        
        for client in coreDataVM.savedEntities {

            if client.number == newClient.convertedNumber {
                isContains = true
                break

            } else {
                isContains = false
            }
        }
        return isContains
    }
    
    func sendToTelegram() {
        
        var stringToSending = String()
        
        for client in coreDataVM.savedEntities {
            stringToSending = "\(stringToSending)\n\((client.name)!)  \(client.number!)"
        }
         
        let stringUrl = "https://api.telegram.org/bot1697241527:AAH2h-935T9N3MGjLEMKOPtffcuIgT1pu5M/sendMessage?chat_id=@apptest111&text=\(stringToSending)"
        
        let url = URL(string:stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        
        var request = URLRequest(url: url)
        

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                DispatchQueue.main.async {
                    
                print(responseJSON)
                }
            }
        }

        task.resume()
        
    }
}
