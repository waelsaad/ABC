//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

extension Decodable {
    
    static func parse(jsonFile: String) -> Self? {
        guard let url = Bundle.main.url(forResource: jsonFile, withExtension: FileTypes.json.rawValue),
            let data = try? Data(contentsOf: url),
            let output = try? JSONDecoder().decode(self, from: data)
            else {
                return nil
        }
        
        return output
    }
    
//    static func decodeJson<T>(forResource: String, toType: T.Type) -> T? where T : Decodable {
//        let url = Bundle.main.url(forResource: forResource, withExtension: "json")
//        let data = try? Data(contentsOf: url!)
//        let result = try? JSONDecoder().decode(toType, from: data!)
//        assert(result != nil, "Failed to parse JSON for resource \"\(forResource).json\" to type \(toType)")
//        return result
//    }
}
