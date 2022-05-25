//
//  Created by Wael Saad - NetTrinity - Copyright © 2021. All rights reserved.
//

import UIKit.UIColor
import UIKit.UIFont

extension Theme.Color {
    
    static let defaultNavigationBackground: UIColor = .clear
    
    static let navigationBackground: UIColor = .lightBlue
    
    static let navigationBarTint: UIColor = .white
    
    static let detailNavigationBackground: UIColor = .white
    
    static let detailNavigationBarTint: UIColor = .lightBlue
}

extension Theme.Font {
    static let hurme15: UIFont = UIFont(name: "HurmeGeometricSans4-SemiBold", size: 15)!
    static let hurme16: UIFont = UIFont(name: "HurmeGeometricSans4-SemiBold", size: 26)!
    static let roman25: UIFont = UIFont(name: "Times New Roman", size: 25)!    
}

extension Theme.StringAttributes {
    static var navigationTitle: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.7
        paragraphStyle.alignment = .center
        
        return [
            .font: UIFont(name: "MissionGothic-Regular", size: 15)!,
            .kern: 1.5,
            .paragraphStyle: paragraphStyle
        ]
    }
    
    static var skipTitle: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0
        paragraphStyle.alignment = .center
        
        return [
            .font: UIFont(name: "HurmeGeometricSans4-SemiBold", size: 15)!,
            .kern: 0,
            .paragraphStyle: paragraphStyle
        ]
    }
}

extension Theme {
    static func applyAppearance(for navigationBar: UINavigationBar, theme: NavigationBarTheme) {
        switch theme {
        case .justIn:
            navigationBar.barStyle = .default
            navigationBar.barTintColor = .white
            navigationBar.tintColor = .black
            //let img = UIImage(named: "TranspireLogo")
            //navigationBar.setBackgroundImage(img, for: .default)
            navigationBar.titleTextAttributes = [
                /*.font: Theme.Font.hurme15,*/
                .foregroundColor: UIColor.black,
                .kern: 1.5] as [NSAttributedString.Key: Any]
        case .anotherScreen:
            navigationBar.barStyle = .default
            navigationBar.isTranslucent = true
            navigationBar.barTintColor = .white
            navigationBar.titleTextAttributes = [/*.font: Theme.Font.navigationBarTitle,*/
                .foregroundColor: UIColor.white,
                .kern: 1.5] as [NSAttributedString.Key: Any]
            navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBar.shadowImage = UIImage()
        }
    }
    
    
}
enum NavigationBarTheme {
    case justIn
    case anotherScreen
}

