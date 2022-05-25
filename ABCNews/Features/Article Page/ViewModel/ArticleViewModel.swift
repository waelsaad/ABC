//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import UIKit
import Foundation

protocol ArticleViewModelType {
    var articleDisplayModel: ActivityFeedDisplayModel { get }
}

class ArticleViewModel: ArticleViewModelType {

    var articleDisplayModel: ActivityFeedDisplayModel

    init(with articleDisplayModel: ActivityFeedDisplayModel) {
        self.articleDisplayModel = articleDisplayModel
    }

    
    // MARK: - Private
    
    private var someVariable = 1
}
