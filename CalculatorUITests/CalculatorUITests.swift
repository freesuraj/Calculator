//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Suraj Pathak on 20/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {

    var app: XCUIApplication!
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        app = nil
    }
    
    func testAddSubstract() {
        // 1.0+2-1 = 1.0 + 2 - 1 = 2
        app.tapButtons("1", ".", "0", "+", "2", "-", "1", "=")
        XCTAssertEqual(app.output, "2")
    }
    
    func testMultiplyDivide() {
        // 45/5*6-7-8-9=30
        app.tapButtons("4", "5", "÷", "5", "×", "6", "-", "7", "-", "8", "-", "9", "=")
        XCTAssertEqual(app.output, "30")
    }
    
    func testClear() {
        // 1+2=3
        // CLEAR = 0
        app.tapButtons("1", "+", "2", "=")
        XCTAssertEqual(app.output, "3")
        app.tapButtons("CLEAR")
        XCTAssertEqual(app.output, "0")
    }
    
    func testDelete() {
        // 11DEL = 1
        app.tapButtons("1", "1", "DEL", "=")
        XCTAssertEqual(app.output, "1")
    }
}

extension XCUIApplication {
    
    fileprivate func tapButtons(_ titles: String...) {
        titles.forEach { buttons[$0].tap() }
    }
    
    var output: String {
        return staticTexts.element(matching: .any, identifier: "OutputLabel").label
    }
}
