//
//  String.swift
//  Movies
//
//  Created by Данил Фролов on 16.01.2022.
//

import Foundation

extension String {
    mutating func addingDevidingPrefixIfNeeded() {
        guard !self.isEmpty else { return }
        self = self + ", "
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
