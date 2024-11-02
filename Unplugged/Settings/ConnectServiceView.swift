//
//  ConnectServiceView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

enum ServiceType: String, Identifiable {
    case instagram_login
    case facebook_login
    case instagram_logout
    case facebook_logout
    
    var id: String { rawValue }
    
    var url: URL {
        switch self {
            case .instagram_login: return URL(string: "https://www.instagram.com/accounts/login/")!
            case .facebook_login: return URL(string: "https://www.facebook.com/login")!
            case .instagram_logout: return URL(string: "https://www.instagram.com/accounts/logout/")!
            case .facebook_logout: return URL(string: "https://www.facebook.com/logout")!
        }
    }
}

struct ConnectServiceView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var instagramProvider: InstagramProvider

    var service: ServiceType!
    
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    self.instagramProvider.refreshLoginState()
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    self.instagramProvider.refreshLoginState()
                    dismiss()
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
