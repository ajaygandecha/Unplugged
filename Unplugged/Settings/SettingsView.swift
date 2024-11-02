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
    @State private var isConnectAccountExpanded: Bool = false
    @State private var isInstagramConnected: Bool = false
    @State private var isFacebookConnected: Bool = false
    
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
                Toggle(isOn: $appSettings.showLikes, label: { Label("Display Likes", systemImage: "heart") })
            }
            .navigationTitle("Settings")
            .sheet(item: $connectAccountSheetConnection) { account in
                ConnectServiceView(service: account)
            }
        }
    }
}

#Preview {
    SettingsView().environmentObject(AppSettings())
}
