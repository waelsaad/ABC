//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import XCTest
import Foundation
@testable import ABCNews


class JustInViewModelTests: XCTestCase {

    private var viewModel: JustInViewModel!
    private var mockAPIClient: MockAPIClient!

    private let justInFeed: FeedResponse = try! Mock.justIn.decoded()

    override func setUp() {
        setUpViewModel()
        continueAfterFailure = false
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIClient = nil
        super.tearDown()
    }
    
    private func setUpViewModel() {
        mockAPIClient = MockAPIClient()
        viewModel = JustInViewModel(apiClient: mockAPIClient)
    }
    
    func testNumberOfSections() {
        let expected = 2
        let current = viewModel.sections.count
        XCTAssertEqual(expected, current)
    }
    
    func test_fetch_justIn_feed() {
        
        // Given
        mockAPIClient.justInResponse = nil
            
        // When
        viewModel.fetchFeed(completion: { _ in })
    
        // Assert
        XCTAssert(mockAPIClient.isFetchCalled)
    }
    
    func test_fetch_justIn_feed_fail() {
        
        // Given a failed fetch with a certain failure
        let error = APIError.unknown
        
        // When
        viewModel.fetchFeed(completion: { _ in })
        
        mockAPIClient.fetchFail(error: error )
        
        // viewModel data should be empty
        XCTAssertEqual(viewModel.data.count, 0)
        
    }
    
    func test_fetch_justIn_feed_success() {

        viewModel.fetchFeed(completion: { result in
            switch result {
            case let .success(data):
                XCTAssertGreaterThan(data.items.count, 0)
            case let .failure(error):
                XCTAssertEqual(error, nil)
            }
        })
        
        mockAPIClient.fetchSuccess()
    }
    
    func test_view_model_data() {

        //Given
        let item: Item = Item(title: "Google Maps to start directing drivers to \'eco-friendly\' routes",
                              pubDate: "2021-03-31 00:17:59",
                              thumbnail: "https://live-production.wcms.abc-cdn.net.au/d3e635bafb2de6c9dabc5fce490aefba?impolicy=wcms_crop_resize&cropH=1281&cropW=961&xPos=480&yPos=0&width=862&height=1149",
                              description: "The eco-friendly routes feature will be launched in the US later this year, with expansion to the rest of the world on the way.",
                              content: nil,
                              enclosure: nil)
        
        //When
        viewModel.fetchFeed(completion: { _ in })
    
        mockAPIClient.fetchSuccess()
        
        //Assert
        XCTAssertEqual(viewModel.data[0].title, item.title)
        XCTAssertEqual(viewModel.data[0].date, item.pubDate)
        XCTAssertEqual(viewModel.data[0].imageURL, item.thumbnailUrl)
        XCTAssertEqual(viewModel.data[0].description, item.description)
        
        //Assert formattedDate
        XCTAssertEqual(viewModel.data[0].formattedDate, "Mar 31, 2021 12:17 AM")
        
    }
}
