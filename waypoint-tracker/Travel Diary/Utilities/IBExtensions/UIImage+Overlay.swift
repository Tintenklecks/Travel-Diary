//

import UIKit

public extension UIImage {
    func addOverlay(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        self.draw(
            in: CGRect(x: 0.0, y: 0.0,
                   width: self.size.width, height: self.size.height))
        image.draw(in:
            CGRect(x: self.size.width - image.size.width,
                   y: self.size.height - image.size.height,
                   width: image.size.width,
                   height: image.size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }
}
