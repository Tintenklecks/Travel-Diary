import Foundation
import UIKit

/// Application Appearance

extension SceneDelegate {
    func setAppearance() {
        
        window?.tintColor = UIColor.action

        UINavigationBar.appearance().barTintColor = .neoWhite
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.highlight,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular),
        ]
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.highlight,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .light),
        ]
        UIView.appearance().tintColor = UIColor.action
        UIButton.appearance().tintColor = UIColor.action
        
        UIBarButtonItem.appearance().tintColor = UIColor.action

        UINavigationBar.appearance().tintColor = .secondaryText

        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = UIColor.neoWhite
        UITableView.appearance().backgroundColor = UIColor.neoWhite
        
        UISegmentedControl.appearance().tintColor = .neoWhite
        UISegmentedControl.appearance().backgroundColor = .neoWhite
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.highlight], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.action], for: .normal)

    
    }
}
