//
//  SelectFriendsView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/3/24.
//

import SwiftUI

struct SelectInstagramFriendsView: View {

    @AppStorage("instagramFriends") var instagramFriends: [String] = []
    @State private var showAddFriendAlert: Bool = false
    @State private var newItemTextBox: String = ""
    
    var body: some View {
        
        List {
            Section {
                ForEach(instagramFriends, id: \.self) { item in
                    HStack(spacing: 0) {
                        Text("@")
                            .foregroundStyle(Color.secondary)
                        Text("\(item)")
                            .swipeActions {
                                Button(role: .destructive) {
                                    instagramFriends = instagramFriends.filter { $0 != item }
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
                Label("Total: \(instagramFriends.count)", systemImage: "person")
            }
        }
        .navigationTitle("Shown Instagram Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Add a new friend here.", isPresented: $showAddFriendAlert) {
            TextField("Enter their username", text: $newItemTextBox)
                .autocorrectionDisabled()
            Button {
                instagramFriends.append(newItemTextBox)
            } label: {
                Text("Add")
            }
        } message: {
            Text("Accounts in this list will be the only to show up on your feed.")
        }
    }
}

#Preview {
    SelectInstagramFriendsView()
}
