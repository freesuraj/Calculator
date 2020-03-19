//
//  Calculator.swift
//  Calculator
//
//  Created by Suraj Pathak on 18/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import Foundation

enum Operator {
    case add, substract, multiply, divide
    var character: Character? {
        switch self {
        case .add: return "+"
        case .substract: return "-"
        case .multiply: return "*"
        case .divide: return "/"
        }
    }
}

enum InputType {
    case decimal
    case number(Character)
    case clear
    case delete
    case op(Operator)
    case equal
    
    var character: Character? {
        switch self {
        case .decimal: return "."
        case .number(let n): return n
        case .clear: return nil
        case .delete: return nil
        case .op(let op): return op.character
        case .equal: return nil
        }
    }
}

class Calculator {
    init() { }
    private var expression: String = "" {
        didSet {
            didUpdateInput?(expression)
        }
    }
    
    private var resetInput: String? = nil
    
    var didUpdateResult: ((String) -> Void)?
    var didUpdateInput: ((String) -> Void)?
    
    func add(_ input: InputType) {
        if let char = input.character {
            add(char: char)
        }
        
        switch input {
        case .clear: clear()
        case .delete: safeDelete()
        case .equal: calculate()
        default: break
        }
    }
    
    private func invert() {
        
    }
    
    private func safeDelete() {
        guard expression.count > 0 else { return }
        expression.removeLast()
    }
    
    private func clear() {
        expression = ""
        resetInput = nil
        didUpdateResult?("0")
    }
    
    // When op is input, it evaluates and makes sure expression is valid
    private func add(char: Character) {
        if let resetInput = resetInput {
            expression = resetInput
            self.resetInput = nil
        }
        let charSet: [Character] = ["-", "+", "*", "/"]
        if let last = expression.last, charSet.contains(last), charSet.contains(char) {
            expression.removeLast()
            expression.append(char)
        } else if let last = expression.last, char == ".", char == last {
            // do nothing
        } else if char == "." {
            // Make sure, the expression can evaluate, otherwise ignore
            guard let _ = evaluate(expression: expression.appending(".0")) else {
                return
            }
            expression.append(char)
            
        } else {
            expression.append(char)
        }
    }
    
    /// Calculates the final value of the expression
    private func calculate() {
        let charSet: [Character] = ["-", "+", "*", "/", "."]
        if let last = expression.last, charSet.contains(last) {
            expression.removeLast()
        }
        
        let invalidFirstCharSet: [Character] = ["+", "*", "/"]
        if let first = expression.first, invalidFirstCharSet.contains(first) {
            expression.removeFirst()
        }
    
        if let result = evaluate(expression: self.expression) {
            didUpdateResult?(result)
            resetInput = result
        }
    }
    
    private func evaluate(expression: String) -> String? {
        var error: NSError!
        var result = ObjcException.catch({ () -> Any in
            let result = NSExpression(format: expression).toDouble().expressionValue(with: nil, context: nil)
            return result ?? ""
        }, error: &error)
        if error != nil { return nil }
        if "\(result)" == "nil" { result = "0" }
        return "\(result)"
    }
}

extension NSExpression {
    
    /// Converts the function and constants into Double type so that result can display decimal precision
    func toDouble() -> NSExpression {
        switch expressionType {
        case .constantValue:
            if let value = constantValue as? NSNumber {
                return NSExpression(forConstantValue: NSNumber(value: value.doubleValue))
            }
        case .function:
           let newArgs = arguments.map { $0.map { $0.toDouble() } }
           return NSExpression(forFunction: operand, selectorName: function, arguments: newArgs)
        default: break
        }
        return self
    }
}

