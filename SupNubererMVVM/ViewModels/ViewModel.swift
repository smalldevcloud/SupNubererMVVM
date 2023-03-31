//
//  ViewModel.swift
//  SupNubererMVVM
//
//  Created by cloud8 on 31.03.23.
//

import Foundation

class ViewModel{
    
    var whatsThat = Dynamic("")
    
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
        SingletoneArrayOfClients.shared.listOfClients.append(tempClient)
        
    }
    
}
