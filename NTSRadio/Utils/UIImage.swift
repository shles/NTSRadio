//
// Created by Timofey on 9/1/17.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {

    public convenience init?(color: UIColor, pointSize: CGSize) {
        let rect = CGRect(origin: .zero, size: pointSize)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

}
