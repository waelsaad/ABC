//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

struct FeedResponse: Codable {
    let status: String?
    let feed: Feed
    let items: [Item]
}

