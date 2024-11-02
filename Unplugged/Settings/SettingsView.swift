//
//  SettingsView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var isConnectAccountExpanded: Bool = true;
    @State private var isInstagramConnected: Bool = false;
    @State private var isFacebookConnected: Bool = false;
    @State private var showLikes: Bool = false;
    
    var body: some View {
        NavigationStack {
            List {
                DisclosureGroup(isExpanded: $isConnectAccountExpanded) {
                    HStack() {
                        Text("Instagram")
                        Spacer()
                        Button(action: {}) {
                            !isInstagramConnected ? Text("Connect") : Text("Disconnect")
                        }
                    }
                    HStack() {
                        Text("Facebook")
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
        }
    }
}

#Preview {
    SettingsView()
}
