//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import XCTest
@testable import ABCNews

final class MockAPIClient: APIRequestProtocol {

    var justInResponse: FeedResponse!

    var isFetchCalled = false

    var completeClosure: ((APIResponse<FeedResponse>) -> ())!
    
    func fetchFeed(completion: @escaping (APIResponse<FeedResponse>) -> Void) {
        isFetchCalled = true
        completeClosure = completion
    }
    
    func fetchSuccess() {
        justInResponse = try! Mock.justIn.decoded()
        completeClosure(.success(justInResponse))
    }
    
    func fetchFail(error: APIError) {
        completeClosure(.failure(.unhandled(error as NSError)))
    }
}
