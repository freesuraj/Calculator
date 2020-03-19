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
    @IBOutlet var outputLabel: UILabel!
    
    /// Maps a button to its type using the button tag
    private var buttonTagToInputTypeMapping: [Int: InputType] = [:]
    
    private var calculator: Calculator!
    override func viewDidLoad() {
        super.viewDidLoad()
        calculator = Calculator()
        calculator.didUpdateInput = { [unowned self] input in
            self.inputLabel.text = input
            print("input: \(input)")
        }
        calculator.didUpdateResult = { [unowned self] output in
            self.outputLabel.text = output
        }
        setupButtons()
        setupMapping()
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
        calculator.add(input)
    }

}

