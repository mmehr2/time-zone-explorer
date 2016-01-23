//
//  LookAndFeel.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/23/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit

class SystemLook {
    
    static func getLogo() -> UIView {
        let label = UILabel()
        label.textColor = lightColor
        label.text = "Time Zone Explorer"
        label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 48) //.systemFontOfSize(40)
        label.numberOfLines = 2
        label.lineBreakMode = .ByWordWrapping
        label.preferredMaxLayoutWidth = 80
        label.sizeToFit()
        
        return label
    }
    
    static var darkColor: UIColor {
        return UIColor.midnight()
    }
    
    static var mediumColor: UIColor {
        return UIColor.sky()
    }
    
    static var lightColor: UIColor {
        return UIColor.banana()
    }
    
}