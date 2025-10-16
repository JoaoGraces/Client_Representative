//
//  Extensions.swift
//  Trabalho
//
//  Created by Scarllet Gomes on 15/10/25.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let email = self.trimmingCharacters(in: .whitespaces)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword() -> Bool {
        let password = self.trimmingCharacters(in: .whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegx)
        return passwordPredicate.evaluate(with: password)
    }
    
    func isValidPhone() -> Bool {
        let phone = self.trimmingCharacters(in: .whitespaces)
        let phoneRegex = #"^\(\d{2}\) \d{4,5}-\d{4}$"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    func formatToBrazilianPhone() -> String {
        
        let digits = self.filter { $0.isNumber }
        
        let limitedDigits = String(digits.prefix(11))
        
        var formatted = ""
        
        for (index, digit) in limitedDigits.enumerated() {
            if index == 0 {
                formatted += "("
            }
            if index == 2 {
                formatted += ") "
            }
            if index == 7 && limitedDigits.count == 11 {
                formatted += "-"
            }
            if index == 6 && limitedDigits.count <= 10 {
                formatted += "-"
            }
            formatted += String(digit)
        }
        
        return formatted
    }
    
    
}
