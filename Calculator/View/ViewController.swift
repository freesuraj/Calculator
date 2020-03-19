//
//  ViewController.swift
//  Calculator
//
//  Created by Suraj Pathak on 18/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var inputLabel: UILabel!
    @IBOutlet var outputLabel: EditableLabel!
    
    /// Maps a button to its type using the button tag
    private var buttonTagToInputTypeMapping: [Int: InputType] = [:]
    
    private var calculator: Calculator!
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator = Calculator()
        calculator.didUpdateInput = { [unowned self] input in
            self.inputLabel.text = input
        }
        calculator.didUpdateResult = { [unowned self] output in
            self.displayOutput(output)
        }
        setupButtons()
        setupMapping()
        listenForPaste()
    }
    
    private func setupButtons() {
        outputLabel.text = "0"
        inputLabel.text = ""
        let buttons: [UIButton] = UIView.getAllSubviews(from: view)
        let selectedImage = UIImage.image(with: UIColor(named: "buttonPressed"))
        buttons.forEach {
            $0.setBackgroundImage(selectedImage, for: .highlighted)
            $0.setBackgroundImage(selectedImage, for: .selected)
            $0.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        }
    }
    
    private func setupMapping() {
        buttonTagToInputTypeMapping = [
            10: .number("0"),
            11: .number("1"),
            12: .number("2"),
            13: .number("3"),
            14: .number("4"),
            15: .number("5"),
            16: .number("6"),
            17: .number("7"),
            18: .number("8"),
            19: .number("9"),
            20: .decimal,
            30: .delete,
            40: .equal,
            50: .clear,
            71: .op(.divide),
            72: .op(.multiply),
            73: .op(.substract),
            74: .op(.add)
        ]
    }
    
    @objc func didPressButton(_ button: UIButton) {
        guard let input = buttonTagToInputTypeMapping[button.tag] else { return }
        calculator.enter(input)
    }
    
    private func listenForPaste() {
        outputLabel.requestToPaste = { [unowned self] in
            guard let pasteboardText = UIPasteboard.general.string else { return }
            guard let _ = pasteboardText.appending("+1").evaluateForValidMathematicalExpression() else {
                return
            }
            self.displayOutput(pasteboardText)
            self.calculator.setDefaultInput(pasteboardText)
        }
    }
    
    /// Formats the output in more readable style
    private func displayOutput(_ text: String) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.groupingSize = 3
        if let double = Double(text) {
           self.outputLabel.text = numberFormatter.string(from: NSNumber(value: double))
        }
    }
    
}

