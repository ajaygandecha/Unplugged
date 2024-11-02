//
//  HomeView.swift
//  Unplugged
//
//  Created by Ajay Gandecha on 11/2/24.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                PostView(post: Post(userImage: "sample", username: "@krisjordan"))
            }
            .navigationTitle("Unplugged")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gear")
                        }

                    }

                }
            }
        }
    }
}

#Preview {
    FeedView()
}
