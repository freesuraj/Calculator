//
//  Calculator.swift
//  Calculator
//
//  Created by Suraj Pathak on 18/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import Foundation

enum InputType {
    case plusMinus
    case decimal
    case number(Int)
    case clear
    case delete
    case percent
    case divide
    case multiply
    case substract
    case add
    case equal
}

class Calculator {
    static let shared = Calculator()
    private init() { }
    private var inputs: [InputType] = [] // Inputs
    
    var didUpdate: ((String, String) -> Void)? // Every input will trigger two outputs, input entry string and output string
    
    func add(_ input: InputType) {
        // Will do logic to output
    }
}
