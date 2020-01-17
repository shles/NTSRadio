//
// Created by Артмеий Шлесберг on 16/06/2017.
// Copyright (c) 2017 Jufy. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func reloadWithAnimation(_ completion: (()->())? = nil) {

        if let view = self.backgroundView, dataSource?.tableView(self, numberOfRowsInSection: 0) != 0 {

            UIView.animate(withDuration: 0.2, animations: {
                view.alpha = 0.0
            }, completion: { _ in
                view.removeFromSuperview()
            })
        }

        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.reloadData()
        }, completion: { _ in
            completion?()
        })
    }

    func showNoItemsText(_ text: String) {

        if let label = self.backgroundView?.subviews.first as? UILabel {

            label.text = text

        } else {

            let view = UIView(frame: self.bounds)
            view.alpha = 0.0

            let label = UILabel(frame: view.bounds.insetBy(dx: 30, dy: 20))
            label.frame.origin.y = 0.0
            label.font = UIFont(name: "HelveticaNeue-Light", size: 21.0)!
            label.textColor = UIColor(white: 0.5, alpha: 1.0)
            label.textAlignment = .center
            label.text = text
            label.numberOfLines = 0
            view.addSubview(label)

            self.backgroundView = view
        }

        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView?.alpha = 1.0
        })
    }

    func dequeueReusableCellOfType<CellType: UITableViewCell>(_ type: CellType.Type, for indexPath: IndexPath) -> CellType {
        let cellName = String(describing: type)
        register(CellType.self, forCellReuseIdentifier: cellName)
        return dequeueReusableCell(withIdentifier: cellName, for: indexPath) as! CellType
    }
    
    func dequeueReusableHeaderOfType<ViewType: UITableViewHeaderFooterView>(_ type: ViewType.Type) -> ViewType {
        let viewName = String(describing: type)
        register(ViewType.self, forHeaderFooterViewReuseIdentifier: viewName)
        return dequeueReusableHeaderFooterView(withIdentifier: viewName) as! ViewType
    }

}
