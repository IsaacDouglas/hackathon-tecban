//
//  UITableView.swift
//  app-ios
//
//  Created by Isaac Douglas on 26/07/20.
//  Copyright © 2020 Isaac Douglas. All rights reserved.
//

import UIKit

extension UITableView {
    func register(cell: UITableViewCell.Type) {
        let identifier = String(describing: cell.self)
        if identifier == UITableViewCell.identifier {
            register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        } else {
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellReuseIdentifier: identifier)
        }
    }

    func addFooterView() {
        let footerView = UIView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        footerView.backgroundColor = backgroundColor
        tableFooterView = UIView()
        tableFooterView?.addSubview(footerView)
    }

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier) as! T
    }

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
