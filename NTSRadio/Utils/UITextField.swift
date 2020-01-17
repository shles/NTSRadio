//
//  UITextField.swift
//  DiscountMarket
//
//  Created by Артмеий Шлесберг on 01/07/2017.
//  Copyright © 2017 Jufy. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension UITextField {
    func with(placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    func with(textAlignment alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
    
    func with(font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func with(keyboard: UIKeyboardType) -> Self {
        self.keyboardType = keyboard
        return self
    }
    
    func with(next responder: UIResponder?, disposeBag: DisposeBag) -> Self {
        self.rx.methodInvoked(#selector(UITextField.resignFirstResponder)).subscribe(onNext: { _ in
            responder?.becomeFirstResponder()
        })
        .disposed(by: disposeBag)
        return self
    }
    
    func with(resignOn controlEvent: UIControlEvents, disposeBag: DisposeBag) -> Self {
        self.rx.controlEvent(controlEvent).subscribe(onNext: { [unowned self] _ in
            self.resignFirstResponder()
        }).disposed(by: disposeBag)
        return self
    }
}
