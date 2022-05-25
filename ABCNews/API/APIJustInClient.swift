//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

protocol APIRequestProtocol {
    func fetchFeed(completion: @escaping (APIResponse<FeedResponse>) -> Void)
}

final class APIJustInClient: APIRequestProtocol {
    
    private let apikManager = APIManager(session: URLSession(configuration: .ephemeral))

    func fetchFeed(completion: @escaping (APIResponse<FeedResponse>) -> Void) {
        
//        apikManager.request(url: EndPoint.justIn.url,
//                            completion: completion)
        
        apikManager.request(url: EndPoint.justIn.url,
                            type: FeedResponse.self,
                            withCompletion: completion)
    }
}
