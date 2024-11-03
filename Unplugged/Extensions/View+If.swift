//
//  Extension+VIew.swift
//  Unplugged
//
//  Created by hacknc on 11/2/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
}
