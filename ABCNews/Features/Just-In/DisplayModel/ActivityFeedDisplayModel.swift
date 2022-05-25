//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import UIKit
import Foundation

protocol ActivityFeedDisplayModelType {
    var title: String? { get set }
    var date: String? { get set }
    var imageURL: URL? { get set }
    var featureImageURL: URL? { get set }
    var description: String? { get set }
}

final class ActivityFeedDisplayModel: ActivityFeedDisplayModelType {
    
    init(activityItem: Item) {
        self.title = activityItem.title
        self.date = activityItem.pubDate
        self.imageURL = activityItem.thumbnailUrl
        self.featureImageURL = activityItem.featureImageURL
        self.description = activityItem.description
    }
    
    // MARK: - ActivityFeedDisplayModel conformance
    
    var title: String?
    var date: String?
    var imageURL: URL?
    var featureImageURL: URL?
    var description: String?
    
    // MARK: - Private
}

extension ActivityFeedDisplayModel {
    var formattedDate: String? {
        return date?.formatedDate
    }
}
