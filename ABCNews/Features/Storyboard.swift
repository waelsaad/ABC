//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

enum Storyboard: String {
    case employeeList
}

extension Storyboard {
    var filename: String {
        let name = rawValue
        guard let first = name.first else { return "" }
        return String(first).uppercased() + name.dropFirst()
    }
}

