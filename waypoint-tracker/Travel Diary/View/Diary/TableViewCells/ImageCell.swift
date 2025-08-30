//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOpacity = 0.3
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)

        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.photoBorder.cgColor
        imageView.clipsToBounds = false
        
    }
    

    func setImage(image: UIImage) {
        self.imageView.image = image
    }
    
}
