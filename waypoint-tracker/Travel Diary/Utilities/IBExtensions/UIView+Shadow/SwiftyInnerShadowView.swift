#if os(iOS)

import UIKit

open class SwiftyInnerShadowView: UIView {
    open var shadowLayer = SwiftyInnerShadowLayer()
    
    open override var bounds: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
    
    open override var frame: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
    
    open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            shadowLayer.cornerRadius = cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initShadowLayer()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initShadowLayer()
    }
    
    fileprivate func initShadowLayer() {
        layer.addSublayer(shadowLayer)
    }
}
#endif
