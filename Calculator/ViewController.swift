//
//  ViewController.swift
//  Calculator
//
//  Created by Suraj Pathak on 18/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
    
    /// Maps a button to its type using the button tag
    private var buttonTagToInputTypeMapping: [Int: InputType] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Calculator.shared.didUpdate = { [weak self] input, output in
            self?.inputLabel.text = input
            self?.outputLabel.text = output
        }
        setupMapping()
    }
    
    override func viewWillLayoutSubviews() {
        outputLabel.text = "0"
        inputLabel.text = nil
        let buttons: [UIButton] = UIView.getAllSubviews(from: view)
        let selectedImage = UIImage.image(with: UIColor(named: "buttonPressed"))
        buttons.forEach {
            $0.setBackgroundImage(selectedImage, for: .highlighted)
            $0.setBackgroundImage(selectedImage, for: .selected)
            $0.addTarget(self, action: #selector(didPressButton), for: .primaryActionTriggered)
        }
    }
    
    private func setupMapping() {
        buttonTagToInputTypeMapping = [
            10: .number(0),
            11: .number(1),
            12: .number(2),
            13: .number(3),
            14: .number(4),
            15: .number(5),
            16: .number(6),
            17: .number(7),
            18: .number(8),
            19: .number(9),
            20: .decimal,
            30: .delete,
            40: .equal,
            50: .clear,
            60: .plusMinus,
            70: .percent,
            71: .divide,
            72: .multiply,
            73: .substract,
            74: .add
        ]
    }
    
    @objc func didPressButton(_ button: UIButton) {
        guard let input = buttonTagToInputTypeMapping[button.tag] else { return }
        Calculator.shared.add(input)
    }

}

