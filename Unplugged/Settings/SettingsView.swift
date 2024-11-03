//
//  SettingsView.swift
//  Unplugged
//
//  Created by Ajay Gandecha and Jade Keegan on 11/2/24.
//

import SwiftUI

class AppSettings: ObservableObject {
    @Published var showLikes: Bool = true;
}

struct SettingsView: View {
    @EnvironmentObject var instagramProvider: InstagramProvider
    @EnvironmentObject var facebookProvider: FacebookProvider
    @EnvironmentObject var twitterProvider: TwitterProvider

    @State private var isConnectAccountExpanded: Bool = false
    @State private var isFacebookConnected: Bool = false
    @State private var isTwitterConnected: Bool = false
    @State private var signinMode: SigninMode = .login
    
    @EnvironmentObject var appSettings: AppSettings
    @Environment(\.dismiss) var dismiss
    
    @State private var connectAccountSheetConnection: ServiceType?

    var body: some View {
        NavigationStack {
            List {
                accountsSection
                preferencesSection
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .sheet(item: $connectAccountSheetConnection) { account in
                ConnectServiceView(service: account, signInMode: $signinMode)
            }
            .onAppear() {
                instagramProvider.refreshLoginState()
                twitterProvider.refreshLoginState()
            }
        }
    }
    
    @ViewBuilder
    private var accountsSection: some View {
        Section {
            HStack() {
                HStack {
                    Image("instagram").resizable()
                        .frame(width: 24, height: 24)
                    Text("Instagram")
                }
                Spacer()
                Button {
                    signinMode = instagramProvider.authState == .loggedIn ? .logout : .login
                    connectAccountSheetConnection = .instagram
                } label: {
                    instagramProvider.authState == .loggedOut ? Text("Connect") : Text("Disconnect")
                }
            }

            HStack() {
                HStack {
                    Image("facebook").resizable()
                        .frame(width: 24, height: 24)
                    Text("Facebook")
                }
                Spacer()
                Button {
                    signinMode = facebookProvider.authState == .loggedIn ? .logout : .login
                    connectAccountSheetConnection = .facebook
                } label: {
                    facebookProvider.authState == .loggedOut ? Text("Connect") : Text("Disconnect")
                }
            }

            HStack() {
                HStack {
                    Image("twitter").resizable()
                        .frame(width: 24, height: 24)
                    Text("Twitter")
                }
                Spacer()
                Button {
                    signinMode = twitterProvider.authState == .loggedIn ? .logout : .login
                    connectAccountSheetConnection = .twitter
                } label: {
                    twitterProvider.authState == .loggedOut ? Text("Connect") : Text("Disconnect")
                }
            }
        } header: {
            Label("Accounts", systemImage: "person.crop.square")
        }

    }
    
    @ViewBuilder
    private var preferencesSection: some View {
        Section {
            Toggle(isOn: $appSettings.showLikes, label: { Label("Display Likes", systemImage: "heart") })
        } header: {
            Label("Preferences", systemImage: "slider.horizontal.3")
        }
    }
}

//#Preview {
//    SettingsView().environmentObject(AppSettings())
//}
