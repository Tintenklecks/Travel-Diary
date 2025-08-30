
#if os(iOS)

import UIKit

public class SwiftyInnerShadowLayer: CAShapeLayer {
    override init() {
        super.init()
        initShadow()
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initShadow()
    }
    
    public override var shadowOffset: CGSize {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override var shadowOpacity: Float {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override var shadowRadius: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override var shadowColor: CGColor? {
        didSet {
            setNeedsLayout()
        }
    }
    
    func initShadow() {
        masksToBounds = true
        shouldRasterize = true
        
        fillRule = CAShapeLayerFillRule.evenOdd
        borderColor = UIColor.clear.cgColor
    }
    
    public override func layoutSublayers() {
        super.layoutSublayers()
        
        generateShadowPath()
    }
    
    func generateShadowPath() {
        let top = shadowRadius - shadowOffset.height
        let bottom = shadowRadius + shadowOffset.height
        let left = shadowRadius - shadowOffset.width
        let right = shadowRadius + shadowOffset.width
        let shadowRect = CGRect(x: bounds.origin.x - left,
                                y: bounds.origin.y - top,
                                width: bounds.width + left + right,
                                height: bounds.height + top + bottom)
        
        let path = CGMutablePath()
        let delta: CGFloat = 1
        let rect = CGRect(x: bounds.origin.x - delta, y: bounds.origin.y - delta, width: bounds.width + delta * 2, height: bounds.height + delta * 2)
        let bezier: UIBezierPath = {
            if cornerRadius > 0 {
                return UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            } else {
                return UIBezierPath(rect: rect)
            }
        }()
        path.addPath(bezier.cgPath)
        path.addRect(shadowRect)
        path.closeSubpath()
        self.path = path
    }
}
#endif
