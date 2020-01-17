//
// Created by Артмеий Шлесберг on 16/06/2017.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func showMessage(_ message: String, withTitle title: String, completion: (()->())? = nil) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            completion?()
        }
        alertController.addAction(OKAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func blockUI() {

        view.isUserInteractionEnabled = false
        navigationItem.backBarButtonItem?.isEnabled = false
    }

    func unblockUI() {

        view.isUserInteractionEnabled = true
        navigationItem.leftBarButtonItem?.isEnabled = true
    }

//    //TODO: This should not be here
//    //TODO: Develop a factory
//    typealias ViewControllerFactory = () -> (UIViewController)
//    func commandToShowController(from factory: @escaping ViewControllerFactory) -> Command {
//        return CommandTo { [weak self] in
//            assert(self?.navigationController != nil)
//            self?.show(factory(), sender: nil)
//        }
//    }

    @objc func hideKeyboardViewDidLoad() {
        hideKeyboardWhenTappedAround()
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        //FIXME: wtf
//        guard !(self is AuthorizationRequestViewController) && !(self is AuthorizationCodeViewController) else {
//            return
//        }
        view.endEditing(true)
    }
    
    func with(tabBarItem item: UITabBarItem) -> Self {
        self.tabBarItem = item
        return self
    }
    
}
