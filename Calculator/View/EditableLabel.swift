//
//  EditableLabel.swift
//  Calculator
//
//  Created by Suraj Pathak on 19/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

import UIKit

/// A label that allows long press for copy and paste menu
@IBDesignable
class EditableLabel: UILabel {

    var requestToPaste: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        self.addGestureRecognizer(gestureRecognizer)
        self.isUserInteractionEnabled = true
    }

    @objc func onLongPress(_ sender: UIGestureRecognizer) {
        switch sender.state {
        case .recognized:
            if let recognizerView = sender.view, let recognizerSuperView = recognizerView.superview, recognizerView.becomeFirstResponder() {
                let menuController = UIMenuController.shared
                let menuFrame = CGRect(origin: .init(x: recognizerView.frame.maxX - 100, y: recognizerView.frame.maxY - 30), size: .init(width: 100, height: 30))
                menuController.showMenu(from: recognizerSuperView, rect: menuFrame)
            }
        default: break
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)))
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
    override func paste(_ sender: Any?) {
        // Do not paste right away, ask the caller to validate first
        requestToPaste?()
    }
}
