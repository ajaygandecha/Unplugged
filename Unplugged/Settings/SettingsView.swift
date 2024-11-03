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
    @EnvironmentObject var twitterProvider: TwitterProvider

    @State private var isConnectAccountExpanded: Bool = false
    @State private var isFacebookConnected: Bool = false
    @State private var isTwitterConnected: Bool = false
    @State private var signinMode: SigninMode = .login
    
    @EnvironmentObject var appSettings: AppSettings

    @State private var connectAccountSheetConnection: ServiceType?

    var body: some View {
        NavigationStack {
            List {

                DisclosureGroup(isExpanded: $isConnectAccountExpanded) {
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
                        Button(action: {}) {
                            !isFacebookConnected ? Text("Connect") : Text("Disconnect")
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
                } label: {
                    Label("Connect Accounts", systemImage: "person.crop.square")
                }
                Toggle(isOn: $appSettings.showLikes, label: { Label("Display Likes", systemImage: "heart") })
            }
            .navigationTitle("Settings")
            .sheet(item: $connectAccountSheetConnection) { account in
                ConnectServiceView(service: account, signInMode: $signinMode)
            }
            .onAppear() {
                instagramProvider.refreshLoginState()
                twitterProvider.refreshLoginState()
            }
        }
    }
}

//#Preview {
//    SettingsView().environmentObject(AppSettings())
//}
