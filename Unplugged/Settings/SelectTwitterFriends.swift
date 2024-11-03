//
//  SelectTwitterFriends.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/3/24.
//

import SwiftUI

struct SelectTwitterFriends: View {

    @AppStorage("twitterFriends") var twitterFriends: [String] = []
    @State private var showAddFriendAlert: Bool = false
    @State private var newItemTextBox: String = ""
    
    var body: some View {
        
        List {
            Section {
                ForEach(twitterFriends, id: \.self) { item in
                    HStack(spacing: 0) {
                        Text("@")
                            .foregroundStyle(Color.secondary)
                        Text("\(item)")
                            .swipeActions {
                                Button(role: .destructive) {
                                    twitterFriends = twitterFriends.filter { $0 != item }
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
                
                Button {
                    showAddFriendAlert.toggle()
                } label: {
                    Label("Add account...", systemImage: "plus")
                }
            } header: {
                Label("Total: \(twitterFriends.count)", systemImage: "person")
            }
        }
        .navigationTitle("Shown Twitter Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Add Account", isPresented: $showAddFriendAlert) {
            TextField("Enter their username", text: $newItemTextBox)
                .autocorrectionDisabled()
            Button {
                twitterFriends.append(newItemTextBox)
            } label: {
                Text("Add")
            }
        } message: {
            Text("Accounts in this list will be the only to show up on your feed.")
        }
    }
}

#Preview {
    SelectTwitterFriends()
}
