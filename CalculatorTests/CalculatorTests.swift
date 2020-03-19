//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Suraj Pathak on 18/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import XCTest
@testable import Calculator

extension Calculator {
    
    fileprivate func evaluateInputs(_ inputs: InputType...) {
        inputs.forEach { enter($0) }
        enter(.equal)
    }
}

class CalculatorTests: XCTestCase {

    var calculator: Calculator!
    
    override func setUp() {
        calculator = Calculator()
    }

    override func tearDown() {
        calculator = nil
    }
    
    func testAddition() {
        // 1+3 = 4
        let expectation = XCTestExpectation(description: "add")
        calculator.didUpdateResult = { result in
            if result == "4" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("1"), .op(.add), .number("3"))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSubstract() {
        // 9-5 = 4
        let expectation = XCTestExpectation(description: "substract")
        calculator.didUpdateResult = { result in
            if result == "4" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("9"), .op(.substract), .number("5"))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDivide() {
        // 8/2 = 4
        let expectation = XCTestExpectation(description: "divide")
        calculator.didUpdateResult = { result in
            if result == "4" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("8"), .op(.divide), .number("2"))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testMultiply() {
        // 9*5 = 45
        let expectation = XCTestExpectation(description: "multiply")
        calculator.didUpdateResult = { result in
            if result == "45" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("9"), .op(.multiply), .number("5"))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLongExpression() {
        // 9*5+32.2/2-0.1 = 61
        let expectation = XCTestExpectation(description: "longExpression")
        calculator.didUpdateResult = { result in
            if result == "61" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("9"), .op(.multiply), .number("5"), .op(.add), .number("3"), .number("2"), .decimal, .number("2"), .op(.divide), .number("2"), .op(.substract), .number("0"), .decimal, .number("1"))
        wait(for: [expectation], timeout: 1.0)
    }


    func testMultipleDecimalEntry() {
        // 9.5.1 + .6 = 10.11 // decimal after the 5 will be ignored
        let expectation = XCTestExpectation(description: "multipleDecimalIgnored")
        calculator.didUpdateResult = { result in
            print("result: \(result)")
            if result == "10.11" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("9"), .decimal, .number("5"), .decimal, .number("1"), .op(.add), .decimal, .number("6"))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testConsecutiveDecimalEntry() {
        // 9...5 + .6 = 10.1 // decimals after the first decimal will be ignored
        let expectation = XCTestExpectation(description: "multipleDecimalIgnored")
        calculator.didUpdateResult = { result in
            print("result: \(result)")
            if result == "10.1" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("9"), .decimal, .decimal, .decimal, .number("5"), .op(.add), .decimal, .number("6"))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testConsecutiveOperatorsEntry() {
           // 9+-*5 + 1 = 46 // the last operator will override the previous operator
           let expectation = XCTestExpectation(description: "multipleDecimalIgnored")
           calculator.didUpdateResult = { result in
               print("result: \(result)")
               if result == "46" { expectation.fulfill() }
           }
        calculator.evaluateInputs(.number("9"), .op(.add), .op(.substract), .op(.multiply), .number("5"), .op(.add), .number("1"))
           wait(for: [expectation], timeout: 1.0)
       }
    
    
    func testZeroDivision() {
        // 9/0 = inf
        let expectation = XCTestExpectation(description: "zeroDivision")
        calculator.didUpdateResult = { result in
            if result == "inf" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("9"), .op(.divide), .number("0"))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testClear() {
        // 1+3 = 4 then clear
        let expectation = XCTestExpectation(description: "clear")
        calculator.didUpdateResult = { result in
            if result == "0" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("1"), .op(.add), .number("3"))
        calculator.enter(.clear)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDelete() {
        // 1+34 delete = 4
        let expectation = XCTestExpectation(description: "delete")
        calculator.didUpdateResult = { result in
            if result == "4" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("1"), .op(.add), .number("3"), .number("4"), .delete)
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvalidExpression() {
        // 1+3/ = 4 the last invalidExpression (/) will be ignored
        let expectation = XCTestExpectation(description: "ignoreInvalid")
        calculator.didUpdateResult = { result in
            if result == "4" { expectation.fulfill() }
        }
        calculator.evaluateInputs(.number("1"), .op(.add), .number("3"), .op(.divide))
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testIgnoreInvalidExpressionInTheBeginning() {
        // *33 = 33
        let expectation = XCTestExpectation(description: "ignoreInvalidBeginning")
        var isValid = true
        calculator.didUpdateInput = { input in
            if input == "*" { isValid = false }
        }
        
        calculator.didUpdateResult = { result in
            if result == "33" { expectation.fulfill() }
        }
        
        calculator.evaluateInputs(.op(.multiply), .number("3"), .number("3"))
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(isValid)
    }

}
