//
//  ConnectServiceView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

enum ServiceType: String, Identifiable {
    case instagram
    case facebook
    
    var id: String { rawValue }
    
    var url: URL {
        switch self {
            case .instagram: return URL(string: "https://instagram.com")!
            case .facebook: return URL(string: "https://facebook.com")!
        }
    }
}

struct ConnectServiceView: View {
    
    var service: ServiceType!
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    //
                } label: {
                    Text("Save")
                }
            }
            .padding(16)
            
            WebView(url: service.url)
        }
    }
}

#Preview {
    ConnectServiceView()
}
