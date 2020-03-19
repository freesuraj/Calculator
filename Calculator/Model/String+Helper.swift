//
//  String+Helper.swift
//  Calculator
//
//  Created by Suraj Pathak on 19/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import Foundation

extension String {
    
    /**
        Evaluates if the expression is a valid mathematical expression
        
        - returns: the mathematical output if it is valid else nil
     */
    func evaluateForValidMathematicalExpression() -> String? {
        var error: NSError!
        var result = ObjcException.catch({ () -> Any in
            let result = NSExpression(format: self).toDouble().expressionValue(with: nil, context: nil)
            return result ?? ""
        }, error: &error)
        if error != nil { return nil }
        if "\(result)" == "nil" { result = "0" }
        return "\(result)"
    }
    
    func formattedNumberOutput() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        if let double = Double(self) {
            return numberFormatter.string(from: NSNumber(value: double)) ?? self
        }
        return self
    }
    
    func formattedExpressionOutput() -> String {
        let regexChar = try? NSRegularExpression(pattern: "([\\*\\-+/])", options: .caseInsensitive)
        guard let charRegex = regexChar else { return self }
        return charRegex.stringByReplacingMatches(in: self, options: .withTransparentBounds, range: NSMakeRange(0, count), withTemplate: " $1 ")
    }
    
}

