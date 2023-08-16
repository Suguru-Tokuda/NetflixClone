//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Suguru on 10/20/22.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return "\(self.prefix(1).uppercased())\(self.lowercased().dropFirst())"
    }
}

extension NSObject {
    var className: String {
        get {
            return NSStringFromClass(type(of: self))
        }
    }
}
