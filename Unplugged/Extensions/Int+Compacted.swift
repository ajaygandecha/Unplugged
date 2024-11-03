//
//  Extensions+Double.swift
//  Unplugged
//
//  Created by Jade Keegan on 11/2/24.
//

import Foundation

extension Int {
    var compacted: String {
        switch self {
            case 1_000...999_999:
                return String(format: "%.1fK", locale: Locale.current, Double(self)/1000)
            case 1_000_000...999_999_999:
                return String(format: "%.1fM", locale: Locale.current, Double(self)/1000000)
            case 1_000_000_000...999_999_999_999:
                return String(format: "%.1fB", locale: Locale.current, Double(self)/1000000000)
            default:
                return String(format: "%d", locale: Locale.current, self)
        }
    }
}
