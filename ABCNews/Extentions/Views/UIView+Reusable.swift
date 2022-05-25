//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

protocol Reusable {

    static var reuseIdentifier: String { get }
}

extension Reusable {

    static var reuseIdentifier: String { return String(describing: self) }
}
