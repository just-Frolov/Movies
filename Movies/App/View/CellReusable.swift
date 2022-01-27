//
//  CellReuseble.swift
//  Movies
//
//  Created by Данил Фролов on 27.01.2022.
//

import UIKit

protocol CellReusable: UITableViewCell {
   
}

extension CellReusable {
    static func dequeueingReusableCell(in tableView: UITableView, for indexPath: IndexPath) -> Self {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Self.self),
                                                 for: indexPath) as! Self
        return cell
    }
}
