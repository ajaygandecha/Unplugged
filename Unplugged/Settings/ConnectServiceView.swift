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
            case .twitter: return "X"
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
            case .instagram: return URL(string: "https://instagram.com/accounts/login")!
            case .facebook: return URL(string: "https://facebook.com/login")!
            case .twitter: return URL(string: "https://facebook.com/login")!
        }
    }

    var logoutURL: URL {
        switch self {
            case .instagram: return URL(string: "https://instagram.com/accounts/logout")!
            case .facebook: return URL(string: "https://facebook.com/logout")!
            case .twitter: return URL(string: "https://facebook.com/logout")!
        }
    }

}

enum SigninMode {
    case login
    case logout
}

struct ConnectServiceView: View {

    @EnvironmentObject var instagramProvider: InstagramProvider
    @Environment(\.dismiss) var dismiss

    var service: ServiceType!
    @Binding var signInMode: SigninMode

    func refreshLoginStates() {
        self.instagramProvider.refreshLoginState()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            instagramProvider.refreshLoginState()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            instagramProvider.refreshLoginState()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            instagramProvider.refreshLoginState()
        }
        // Add facebook here
    }

    var body: some View {
        VStack {
            HStack {
                Button {
                    refreshLoginStates()
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                Spacer()
                Button {
                    refreshLoginStates()
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
            .padding(16)

            WebView(url: signInMode == .login ? service.url : service.logoutURL)
        }
    }
}

#Preview {
    ConnectServiceView(service: .instagram, signInMode: .constant(.login))
}
