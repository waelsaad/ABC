//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

struct Item: Codable {
    let title: String?
    let pubDate: String?
    let thumbnail: String?
    let description: String?
    let content: String?
    let enclosure: Enclosure?
}

extension Item {
    var featureImageURL: URL? {
        if let urlString = enclosure?.link,
            let url = URL(string: urlString) {
            return url
        }
        return nil
    }
    
    var thumbnailUrl: URL? {
        if let urlString = thumbnail,
            let url = URL(string: urlString) {
            return url
        }
        return nil
    }
}
