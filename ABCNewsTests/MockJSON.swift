//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

enum Mock: String {
    
    case justIn = "JustIn"

    private var data: Data {
        return loadMockJSON(for: rawValue)
    }

    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}

private func loadMockJSON(for name: String) -> Data {
    let path = Bundle.main.path(forResource: name, ofType: "json")!
    return try! Data(contentsOf: URL(fileURLWithPath: path))
}

