//
//  HomeTab.swift
//  SchoolAssisstant
//
//  Created by Léonard Dinichert on 07.04.2025.
//

import SwiftUI

struct HomeTab: View {
    
    @StateObject private var viewModel = userManagerViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    @StateObject private var statsModel = StatsViewModel()
    @Binding var selectedTab: Tab
    @State private var showStudyState: Bool = false


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
                            Text("Start a study session")
                        }
                        .primaryButtonStyle()
                        .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            Text("You're on a \(statsModel.streak) day streak!")
                                .font(.headline)

                            if !notesViewModel.notes.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("Recent Notes")
                                        .font(.headline)
                                    ForEach(notesViewModel.notes.prefix(3)) { note in
                                        Text(note.text)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(8)
                                            .background(AppTheme.cardBackground)
                                            .cornerRadius(AppTheme.cornerRadius)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            if !viewModel.leaderboard.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("Friends")
                                        .font(.headline)
                                    ForEach(viewModel.leaderboard.prefix(5), id: \.userId) { friend in
                                        if friend.userId != viewModel.user?.userId {
                                            HStack {
                                                Text(friend.username ?? "Unknown")
                                                Spacer()
                                                Button("Nudge") {
                                                    viewModel.sendNotificationRequest(title: "Time to study!", body: "Let's work together", token: friend.fcmToken)
                                                }
                                                .buttonStyle(.bordered)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        
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
                if viewModel.user?.studyState == nil {
                    showStudyState = true
                }
                await notesViewModel.loadNotes()
                await statsModel.load()
                await viewModel.loadLeaderboard()
            }
        }
        .fullScreenCover(isPresented: $showStudyState) {
            StudyStateView(show: $showStudyState)
        }
    }
}

#Preview {
    HomeTab(selectedTab: .constant(.home))
}
