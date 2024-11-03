//
//  OnboardingView.swift
//  Unplugged
//
//  Created by Jade Keegan on 11/2/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var ig: InstagramProvider
    @State private var connectAccountSheetConnection: ServiceType?
    @State private var signinMode: SigninMode = .login
    
    var body: some View {
        TabView {
            VStack(spacing: 20) {
                Text("Welcome to Unplugged")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.horizontal, 20)
                Text("Swipe left to begin.")
                    .font(.headline)
                    .padding(.horizontal, 20)
            }
            VStack(spacing: 20) {
                Text("Connect Accounts")
                    .font(.largeTitle)
                List {
                    Button {
                        signinMode = .login
                        connectAccountSheetConnection = .instagram
                    } label: {
                        HStack {
                            Image("instagram").resizable()
                                .frame(width: 24, height: 24)
                            Text(ig.authState == .loggedOut ? "Connect Instagram" : "Connected")
                        }
                    }.disabled(ig.authState == .loggedIn)
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Image("facebook").resizable()
                                .frame(width: 24, height: 24)
                            Text("Connect Facebook")
                        }
                    }
                    Button {
                        
                    } label: {
                        HStack {
                            Image("twitter").resizable()
                                .frame(width: 24, height: 24)
                            Text("Connect X")
                        }
                    }
                }
                
                if self.ig.authState == .loggedIn {
                    NavigationLink {
                        FeedView()
                    } label: {
                        Button {
                        } label: {
                            Text("Done")
                        }
                    }
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .padding(.vertical, 20)
        .sheet(item: $connectAccountSheetConnection) { account in
            ConnectServiceView(service: account, signInMode: $signinMode)
        }
        .onAppear() {
            ig.refreshLoginState()
        }
    }
}
