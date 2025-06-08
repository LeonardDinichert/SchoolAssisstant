//
//  HomeTab.swift
//  SchoolAssisstant
//
//  Created by Léonard Dinichert on 07.04.2025.
//

import SwiftUI

struct HomeTab: View {
    
    @StateObject private var viewModel = userManagerViewModel()
    @Binding var selectedTab: Tab


    var body: some View {
        NavigationStack {
            ScrollView {
                if let user = viewModel.user {
                    VStack {
                        Text("Hello \(user.username ?? "No user"), let's work !")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        Button {
                            selectedTab = .studySession
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                                    .frame(height: 100)
                                    .padding(.horizontal)
                                    .foregroundStyle(.orange).opacity(0.2)
                                
                                Text("Start a study session")
                            }
                        }
                        
                        Text("Streak and social things view")
                        
                        
                    }
                    
                } else {
                    // MARK: - Loading / Not Logged In
                    VStack(spacing: 16) {
                        Text("Loading...")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        ProgressView()
                            .font(.title)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            Task {
                try await viewModel.loadCurrentUser()
            }
        }
    }
}

#Preview {
    HomeTab(selectedTab: .constant(.home))
}
