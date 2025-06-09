//
//  HomeTab.swift
//  SchoolAssisstant
//
//  Created by Léonard Dinichert on 07.04.2025.
//

import SwiftUI
import Charts

struct HomeTab: View {
    
    @StateObject private var viewModel = userManagerViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    @StateObject private var statsModel = StatsViewModel()
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
                            Text("Start a study session")
                        }
                        .primaryButtonStyle()
                        .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            Text("\(statsModel.streak) day streak! Keep it up!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)

                            if !statsModel.dailyTotals.isEmpty {
                                Chart {
                                    ForEach(statsModel.dailyTotals, id: \.day) { entry in
                                        BarMark(
                                            x: .value("Day", entry.day, unit: .day),
                                            y: .value("Minutes", entry.minutes)
                                        )
                                        .foregroundStyle(AppTheme.primaryColor)
                                    }
                                }
                                .chartXAxisLabel("Day")
                                .chartYAxisLabel("Minutes")
                                .frame(height: 200)
                            }

//                            if !notesViewModel.notes.isEmpty {
//                                VStack(alignment: .leading) {
//                                    Text("Recent Notes")
//                                        .font(.headline)
//                                    ForEach(notesViewModel.notes.prefix(3)) { note in
//                                        Text(note.text)
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                            .padding(8)
//                                            .background(AppTheme.cardBackground)
//                                            .cornerRadius(AppTheme.cornerRadius)
//                                    }
//                                }
//                                .padding(.horizontal)
//                            }
                            if !viewModel.leaderboard.isEmpty {
                                VStack(alignment: .leading) {
                                    Text("Friends")
                                        .font(.headline)
                                    ForEach(viewModel.leaderboard.prefix(5), id: \.userId) { friend in
                                        if friend.userId != viewModel.user?.userId {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(friend.username ?? "Unknown")
                                                    Spacer()
                                                    Button("Nudge") {
                                                        viewModel.sendNotificationRequest(title: "Time to study!", body: "Let's work together", token: friend.fcmToken)
                                                    }
                                                    .buttonStyle(.bordered)
                                                }
                                                if let last = friend.lastConnection {
                                                    Text("Last online: \(last, style: .time)")
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
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
                await notesViewModel.loadNotes()
                await statsModel.load()
                await viewModel.loadLeaderboard()
                scheduleReminder()
            }
        }
    }

    private func scheduleReminder() {
        NotificationManager.cancelAll()
        let cal = Calendar.current
        let now = Date()
        if let last = viewModel.user?.lastConnection, cal.isDateInToday(last) {
            return
        }
        var components = cal.dateComponents([.year, .month, .day], from: now)
        components.hour = 20
        components.minute = 0
        let target = cal.date(from: components) ?? now
        NotificationManager.scheduleNotification(title: "Time to study!", body: "You haven't logged in today", at: target)
    }
}

#Preview {
    HomeTab(selectedTab: .constant(.home))
}
