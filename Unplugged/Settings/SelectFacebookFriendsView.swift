//
//  SelectFacebookFriendsView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/3/24.
//

import SwiftUI

struct SelectFacebookFriendsView: View {

    @AppStorage("facebookFriends") var facebookFriends: [String] = []
    @State private var showAddFriendAlert: Bool = false
    @State private var newItemTextBox: String = ""
    
    var body: some View {
        
        List {
            Section {
                ForEach(facebookFriends, id: \.self) { item in
                    HStack(spacing: 0) {
                        Text("@")
                            .foregroundStyle(Color.secondary)
                        Text("\(item)")
                            .swipeActions {
                                Button(role: .destructive) {
                                    facebookFriends = facebookFriends.filter { $0 != item }
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
                Label("Total: \(facebookFriends.count)", systemImage: "person")
            }
        }
        .navigationTitle("Shown Facebook Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Add Account", isPresented: $showAddFriendAlert) {
            TextField("Enter their username", text: $newItemTextBox)
                .autocorrectionDisabled()
            Button {
                facebookFriends.append(newItemTextBox)
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
