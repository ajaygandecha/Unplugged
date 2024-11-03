//
//  ConnectServiceView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

enum ServiceType: String, Identifiable, CaseIterable {
    case instagram
    case facebook
    case twitter
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
            case .instagram: return "Instagram"
            case .facebook: return "Facebook"
            case .twitter: return "Twitter"
        }
    }
    
    var logo: String {
        switch self {
            case .instagram: return "instagram"
            case .facebook: return "facebook"
            case .twitter: return "twitter"
        }
    }
    
    var url: URL {
        switch self {
            case .instagram: return URL(string: "https://instagram.com")!
            case .facebook: return URL(string: "https://facebook.com")!
            case .twitter: return URL(string:
                "https://x.com")!
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
    ConnectServiceView(service: .instagram)
}
