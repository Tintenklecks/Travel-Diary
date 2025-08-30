//
//  UIButton+SoftUI.swift
//  SoftUI
//
//  Created by Mumtaz on 21/01/2020.
//  Copyright © 2020 Mumtaz. All rights reserved.
//

import UIKit

extension UIButton {
    open override var isSelected: Bool {
        didSet {
            if isSelected {
                setState()
            } else {
                resetState()
            }
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                setState()
            } else {
                resetState()
            }
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            if self.isEnabled == false {
                self.setState()
            } else {
                self.resetState()
            }
        }
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setState()
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetState()
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetState()
        super.touchesCancelled(touches, with: event)

    }
    
    func setState() {
        self.layer.shadowOffset = CGSize(width: -2, height: -2)
        self.layer.sublayers?[0].shadowOffset = CGSize(width: 2, height: 2)
        self.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
    }
    
    func resetState() {
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.sublayers?[0].shadowOffset = CGSize(width: -1, height: -1)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 1)
    }
    
    public func addSoftUIEffectForButton(cornerRadius: CGFloat = 15.0, themeColor: UIColor = UIColor(red: 241 / 255, green: 243 / 255, blue: 246 / 255, alpha: 1.0)) {
        
     //   self.layer.sublayers?.removeAll()
     //TODO:   print("LAYERS: \(self.layer.sublayers?.count ?? 0)")
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowColor = UIColor.neoDarkShadow.cgColor // UIColor(red: 223 / 255, green: 228 / 255, blue: 238 / 255, alpha: 1.0).cgColor
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = themeColor.cgColor
        shadowLayer.shadowColor = UIColor.neoLightShadow.cgColor // UIColor.white.cgColor
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.shadowOffset = CGSize(width: -1.0, height: -1.0)
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowRadius = 1
        self.layer.insertSublayer(shadowLayer, below: self.imageView?.layer)
    }
}

