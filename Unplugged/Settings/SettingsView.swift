//
//  SettingsView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var isConnectAccountExpanded: Bool = false;
    @State private var isInstagramConnected: Bool = false;
    @State private var isFacebookConnected: Bool = false;
    
    @State private var showAccountInfo: Bool = false;
    @State private var showLikes: Bool = false;

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
                            if isInstagramConnected {
                                
                            } else {
                                connectAccountSheetConnection = .instagram
                            }
                        } label: {
                            !isInstagramConnected ? Text("Connect") : Text("Disconnect")
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
                } label: {
                    Label("Connect Accounts", systemImage: "person.crop.square")
                }
                Toggle(isOn: $showLikes, label: { Label("Display Likes", systemImage: "heart") })
            }
            .navigationTitle("Settings")
            .sheet(item: $connectAccountSheetConnection) { account in
                ConnectServiceView(service: account)
            }
        }
    }
}

#Preview {
    SettingsView()
}
