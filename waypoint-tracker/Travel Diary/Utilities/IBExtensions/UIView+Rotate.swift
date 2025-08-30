import UIKit

#if os(iOS)
public extension UIView
{
    func rotate(degrees: CGFloat)
    {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }

    func rotate(radians: CGFloat)
    {
        transform = CGAffineTransform(rotationAngle: radians)
    }
}
#endif
