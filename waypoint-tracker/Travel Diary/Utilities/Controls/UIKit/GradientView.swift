//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var leftToRight: Bool = true
    @IBInspectable var horizontal: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setGradient()
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        self.setGradient()
    }

    func setGradient() {
        let colorStart: UIColor = UIColor.neoWhite.withAlphaComponent(0.98)
        let colorMiddle: UIColor = UIColor.neoWhite.withAlphaComponent(0.95)
        let colorEnd: UIColor = UIColor.neoWhite.withAlphaComponent(0)
        let gradient = CAGradientLayer()
        gradient.colors = [colorStart.cgColor,
                           colorMiddle.cgColor,
                           colorEnd.cgColor]
        if !leftToRight {
            gradient.colors = gradient.colors?.reversed()
        }
        if horizontal {
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)

        }
        gradient.frame = self.bounds
        self.layer.sublayers?.removeAll()
        self.layer.insertSublayer(gradient, at: 0)
        self.backgroundColor = .clear
    }

}
