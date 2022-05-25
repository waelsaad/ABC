//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import Foundation

extension String {
    
    static let empty: String = ""
    
    public var localized: String {
        return NSLocalizedString(self, comment: .empty)
    }
    
    func localizedWithFormat(args: CVarArg...) -> String {
        return String(format: localized, locale: NSLocale.current, arguments: args)
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
