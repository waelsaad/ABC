//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import XCTest
import Foundation
@testable import ABCNews

class APIManagerTests: XCTestCase {

    private var apikManager: APIManager!
    
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        apikManager = APIManager(session: session)
    }
    
    override func tearDown() {}
    
    func testFetchFeed() {
        
        //Given
        let expectedData = "{}".data(using: .utf8)
        let dataTask = MockURLSessionDataTask()
        var actualData: APIResponse<FeedResponse>?

        //When
        session.nextDataTask = dataTask
        session.nextData = expectedData
        
        apikManager.request(url: EndPoint.justIn.url,
                            type: FeedResponse.self,
                            withCompletion: { response in
                                actualData = response
                            })
        
        //Then
        XCTAssertNotNil(actualData)
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testFetchFeedWithEndPoint() {
        
        let endPointURL = "https://api.rss2json.com/v1/api.json?rss_url=http://www.abc.net.au/news/feed/51120/rss.xml"
        
        let url = URL(string: endPointURL)!
        let urlExpectation = expectation(description: "GET \(endPointURL)")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            XCTAssertNil(error, "error should be nil")
            XCTAssertNotNil(data, "data should not be nil")
            
            if let response = response as? HTTPURLResponse,
                let responseURL = response.url {
                XCTAssertEqual(responseURL.absoluteString,
                               url.absoluteString,
                               "HTTP response URL should be equal to original URL")
                
                XCTAssertEqual(response.statusCode, 200,
                               "HTTP response status code should be 200")
                
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }
            
            urlExpectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
}
