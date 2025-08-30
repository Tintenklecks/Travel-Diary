import UIKit

// MARK: - HEADER

class DiaryHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet var leftLabel: UILabel?

    @IBOutlet var rightLabel: UILabel?
    @IBOutlet var yearLabel: UILabel?

    @IBOutlet  var shadowView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    func setDate(_ date: Date) {        
        let gradientView = GradientView()
        gradientView.horizontal = false
        
        self.backgroundView = gradientView
        self.shadowView?.backgroundColor = .clear
        self.setAccessability(.diaryHeaderCell, with: date.weekdayText + " " + date.longDate)
        leftLabel?.text = date.weekdayText
        rightLabel?.text = date.monthAndDay
        if date.isCurrentYear {
            yearLabel?.text = ""
        } else {
            yearLabel?.text = "\(date.year)"
        }        
        yearLabel?.text = "\(date.year)"

    }
}

//

// MARK: - FOOTER

//
class CustomTableViewFooter: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
