//
//  UIFont.swift
//  NTSRadio
//
//  Created by Артмеий Шлесберг on 17/03/2018.
//  Copyright © 2018 Shlesberg. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    static func universLTPro(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "UniversLTPro-BoldCond", size: size)!
    }
    static func universCondensed(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Univers-CondensedLight", size: size)!
    }
}
