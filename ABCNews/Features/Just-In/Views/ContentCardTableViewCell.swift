//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import UIKit
import Foundation

protocol ContentCardTableViewCellDelegate: class {
    
}

final class ContentCardTableViewCell: UITableViewCell, ViewWithNib, Reusable {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var featureImageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    // MARK: - Configure View
    
    func configure(with displayModel: ActivityFeedDisplayModel) {
        
        self.displayModel = displayModel
        
        titleLabel.text = displayModel.title
        dateLabel.text = displayModel.formattedDate
        
        if let url = displayModel.imageURL {
            featureImageView.load(url: url)
        }
    }
    
    var displayModel: ActivityFeedDisplayModel?
    
    weak var delegate: ContentCardTableViewCellDelegate?
}

// MARK: - Actions ⚡️

extension ContentCardTableViewCell {
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
