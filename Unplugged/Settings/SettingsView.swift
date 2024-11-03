//
//  SettingsView.swift
//  Unplugged
//
//  Created by Ajay Gandecha and Jade Keegan on 11/2/24.
//

import SwiftUI

class AppSettings: ObservableObject {
    @Published var showLikes: Bool = true
    @Published var hideVideos: Bool = false
    
    @Published var filterInstagramFriends: Bool = false
    @Published var filterFacebookFriends: Bool = false
    @Published var filterTwitterFriends: Bool = false

}

struct SettingsView: View {
    @EnvironmentObject var instagramProvider: InstagramProvider
    @EnvironmentObject var facebookProvider: FacebookProvider
    @EnvironmentObject var twitterProvider: TwitterProvider
    @EnvironmentObject var feedService: FeedService

    @AppStorage("instagramFriends") var instagramFriends: [String] = []
    @AppStorage("facebookFriends") var facebookFriends: [String] = []
    @AppStorage("twitterFriends") var twitterFriends: [String] = []

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
                    instagramProvider.authState == .loggedOut ? Text("Connect") : Text("Disconnect").foregroundStyle(Color.red)
                }
            }
            
            if instagramProvider.authState == .loggedIn {
                Toggle(isOn: $appSettings.filterInstagramFriends, label: { Text("Limit Accounts") })
                    .onChange(of: appSettings.showLikes) { oldValue, newValue in
                        feedService.reset()
                    }
            }
            
            if instagramProvider.authState == .loggedIn && appSettings.filterInstagramFriends {
                NavigationLink {
                    SelectInstagramFriendsView()
                } label: {
                    HStack {
                        Text("Shown Accounts")
                        Spacer()
                        Text("\(instagramFriends.count) shown")
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
            
        } header: {
            Label("Accounts", systemImage: "person.crop.square")
        }
        
        Section {
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
                    facebookProvider.authState == .loggedOut ? Text("Connect") : Text("Disconnect").foregroundStyle(Color.red)
                }
            }
            
            if facebookProvider.authState == .loggedIn {
                Toggle(isOn: $appSettings.filterFacebookFriends, label: { Text("Limit Accounts") })
                    .onChange(of: appSettings.filterFacebookFriends) { oldValue, newValue in
                        feedService.reset()
                    }
            }
            
            if facebookProvider.authState == .loggedIn && appSettings.filterFacebookFriends {
                NavigationLink {
                    SelectFacebookFriendsView()
                } label: {
                    HStack {
                        Text("Shown Accounts")
                        Spacer()
                        Text("\(facebookFriends.count) shown")
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
        }
        
        Section {
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
                    twitterProvider.authState == .loggedOut ? Text("Connect") : Text("Disconnect").foregroundStyle(Color.red)
                }
            }
            
            if twitterProvider.authState == .loggedIn {
                Toggle(isOn: $appSettings.filterTwitterFriends, label: { Text("Limit Accounts") })
                    .onChange(of: appSettings.filterTwitterFriends) { oldValue, newValue in
                        feedService.reset()
                    }
            }
            
            if twitterProvider.authState == .loggedIn && appSettings.filterTwitterFriends {
                NavigationLink {
                    SelectTwitterFriends()
                } label: {
                    HStack {
                        Text("Shown Accounts")
                        Spacer()
                        Text("\(twitterFriends.count) shown")
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
        }

    }
    
    @ViewBuilder
    private var preferencesSection: some View {
        Section {
            Toggle(isOn: $appSettings.showLikes, label: { Label("Display Likes", systemImage: "heart") })
                .onChange(of: appSettings.showLikes) { oldValue, newValue in
                    feedService.reset()
                }
            Toggle(isOn: $appSettings.hideVideos, label: { Label("Hide Videos from Feed", systemImage: "video") })
                .onChange(of: appSettings.hideVideos) { oldValue, newValue in
                    feedService.reset()
                }
                
        } header: {
            Label("Preferences", systemImage: "slider.horizontal.3")
        }
    }
}

//#Preview {
//    SettingsView().environmentObject(AppSettings())
//}
