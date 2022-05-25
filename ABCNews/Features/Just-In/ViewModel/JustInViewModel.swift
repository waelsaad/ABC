//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import UIKit
import Foundation

protocol JustInViewModelType {
    var title: String { get }
    var data: [ActivityFeedDisplayModel] { get set }
    func fetchFeed(completion: @escaping (APIResponse<FeedResponse>) -> Void)
    func displayError(error: APIError)
}

class JustInViewModel: JustInViewModelType {

    var data: [ActivityFeedDisplayModel] = []
    
    var sections: [Section] {
        return [.featureArticle, .contentArticle]
    }
    
    var title: String {
        return "JUST.IN.NAVIGATION.TITLE".localized
    }
    
    private var apiClient: APIRequestProtocol

    init(apiClient: APIRequestProtocol = APIJustInClient()) {
        self.apiClient = apiClient
    }
    
    func fetchFeed(completion: @escaping (APIResponse<FeedResponse>) -> Void) {
        apiClient.fetchFeed(completion: { [weak self] (result: APIResponse<FeedResponse>) in
            switch result {
            case let .success(data):
                self?.handleSuccess(data: data)
                completion(.success(data))
            case let .failure (error):
                completion(.failure(error))
            }
        })
    }
    
    func handleSuccess(data: FeedResponse) {
        for item in data.items {
            self.data.append(ActivityFeedDisplayModel(activityItem: item))
        }
    }

    func displayError(error: APIError) {
        UIAlert.display("APP.ALERT.TITLE".localized,
                        message: error.description,
                        buttons: ["APP.ALERT.CONFIRM".localized],
                        buttonsPreferredStyle: [.default]) { (alert, action) in
                            switch alert.style {
                            default:
                                break
                            }
        }
    }
    
    // MARK: - Private
    
    private var pageNumber = 1
}

// MARK: - Sections

extension JustInViewModel {
    
    enum Section: Int, CaseIterable {
        
        case featureArticle = 0
        case contentArticle
        
        init(section: Int) {
            self = Section(rawValue: section)!
        }
        
        var cellHeight: CGFloat {
            switch self {
            case .featureArticle:
                return 470
            case .contentArticle:
                return 170
            }
        }
    }
    
    func section(at indexPath: IndexPath) -> Section? {
        return sections[indexPath.section]
    }
    
    func getSectionIndexBy(type: Section) -> Int? {
        return sections.firstIndex(of: type)
    }
}
