//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation
@testable import ABCNews

class MockURLSession: URLSessionProtocol {
    
    var nextData: Data?
    var nextError: Error?
    var nextDataTask = MockURLSessionDataTask()

    func successHttpURLResponse(url: URL) -> URLResponse {
        return HTTPURLResponse(url: url,
                               statusCode: 200,
                               httpVersion: "HTTP/1.1",
                               headerFields: nil)!
    }
    
    func dataTask(url: URL,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        
        completionHandler(nextData, successHttpURLResponse(url: url),
                          nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
