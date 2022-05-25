//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import UIKit

extension UIApplication {
    var topMostViewController: UIViewController? {
        return UIApplication.shared.windows
            .filter { $0.isKeyWindow }
            .first?.rootViewController?
            .topMostViewController()
    }
}
