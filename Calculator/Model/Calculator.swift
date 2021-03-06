//
//  Calculator.swift
//  Calculator
//
//  Created by Suraj Pathak on 18/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import Foundation

enum Operator: Character, CaseIterable {
    case add = "+"
    case substract = "-"
    case multiply = "*"
    case divide = "/"
    
    static var allOps = Operator.allCases.compactMap { $0.rawValue }
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
        case .op(let op): return op.rawValue
        case .equal: return nil
        }
    }
}

class Calculator {
    init() { }
    
    private var invalidStartChar: [Character] = ["+", "*", "/"]
    private var invalidEndChar: [Character] = Operator.allOps
    
    private var expression: String = "" {
        didSet {
            didUpdateInput?(expression)
        }
    }
    
    private var resetInput: String? = nil
    
    var didUpdateResult: ((String) -> Void)?
    var didUpdateInput: ((String) -> Void)?
    
    func enter(_ input: InputType) {
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
    
    /// Sets the default input to this value
    func setDefaultInput(_ input: String) {
        resetInput = input
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
    
    private func add(char: Character) {
        if let resetInput = resetInput {
            expression = resetInput
            self.resetInput = nil
        }
        
        if expression.count == 0, invalidStartChar.contains(char) {
            // skip
        } else if let last = expression.last, invalidEndChar.contains(last), invalidEndChar.contains(char) {
            expression.removeLast()
            expression.append(char)
        } else if char == "." {
            // Make sure, the expression can evaluate, otherwise ignore
            guard let _ = expression.appending(".0").evaluateForValidMathematicalExpression() else {
                return
            }
            expression.append(char)
            
        } else {
            expression.append(char)
        }
    }
    
    /// Calculates the final value of the expression
    private func calculate() {
        let ignoreLastCharSet: [Character] = invalidEndChar + "."
        if let last = expression.last, ignoreLastCharSet.contains(last) {
            expression.removeLast()
        }
    
        if let result = self.expression.evaluateForValidMathematicalExpression() {
            didUpdateResult?(result)
            resetInput = result
        }
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
