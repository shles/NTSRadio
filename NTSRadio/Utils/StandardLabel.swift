//
//  StandardLabel.swift
//  DiscountMarket
//
//  Created by Timofey on 5/31/17.
//  Copyright © 2017 Jufy. All rights reserved.
//

import UIKit
import RxSwift

class StandardLabel: UILabel {

    class CrossedTextLabel: StandardLabel {

        init(font: UIFont, textColor: UIColor) {
            super.init(font: font, textColor: textColor)
            self.numberOfLines = 1
        }

        init() {
            super.init()
            self.numberOfLines = 1
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        final override var text: String? {
            get {
                return attributedText?.string
            }
            set {
                guard let newValue = newValue else { attributedText = nil; return }
                attributedText = NSAttributedString(string: newValue)
            }
        }

        final override var attributedText: NSAttributedString? {
            get {
                return super.attributedText
            }
            set {
                guard let newValue = newValue else { super.attributedText = nil; return }
                super.attributedText = NSAttributedString(
                    string: newValue.string,
                    attributes: [
                        NSAttributedStringKey.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue)
                    ]
                )
            }
        }
    }


    init(font: UIFont = .universLTPro(ofSize: 14), textColor: UIColor = .black, text: String? = nil) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.numberOfLines = 0
        self.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
