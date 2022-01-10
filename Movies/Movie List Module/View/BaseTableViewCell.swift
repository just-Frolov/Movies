//
//  BaseTableViewCell.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

class BaseTableViewCell: UITableViewCell, TableRegistable, CellReusable {

}

protocol TableRegistable: UITableViewCell {
    
}

extension TableRegistable {
    static func register(in tableView: UITableView) {
        tableView.register(Self.self,
                           forCellReuseIdentifier: String(describing: self))
    }
    
    static func xibRegister(in tableView: UITableView) {
        tableView.register(UINib(nibName: String(describing: self), bundle: nil), forCellReuseIdentifier: String(describing: self))
    }
}

protocol CellReusable: UITableViewCell {
   
}

extension CellReusable {
    static func dequeueingReusableCell(in tableView: UITableView, for indexPath: IndexPath) -> Self {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Self.self),
                                                 for: indexPath) as! Self
        return cell
    }
}



