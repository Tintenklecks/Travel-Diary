//

import UIKit


// MARK: - CELL


class DiaryEntryTableViewCell: UITableViewCell {
    
    
        var entry : DiaryEntryViewModel? {
        didSet {
            if let entry = entry {
    //    entryImage.image = entry?.entryImage
    //    entryNameLabel.text = entry?.entryName
    //    descriptionLabel.text = "\(entry.arrivalTime) - \(entry.departureTime)"
            }
            
            }
        }
        

    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//

// MARK: - HEADER

//
class CustomTableViewHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .orange
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//

// MARK: - FOOTER

//
class CustomTableViewFooter: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .green
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
