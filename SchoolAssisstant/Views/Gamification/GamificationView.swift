import SwiftUI

/// Dashboard showcasing Duolingo-style gamification elements.
struct GamificationView: View {
    @StateObject private var manager = GamificationManager.shared
    @State private var newFriendName: String = ""
    @State private var streakScale: CGFloat = 1

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let message = manager.weeklyResult {
                        Text(message)
                            .font(.subheadline)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue.opacity(0.2)))
                    }
                    streakSection
                    xpSection
                    heartsSection
                    gemsSection
                    lessonsSection
                    achievementsSection
                    leaderboardSection
                    friendsSection
                }
                .padding()
            }
            .navigationTitle("Progress")
            .onAppear {
                manager.updateStreak()
                manager.sortLeaderboard()
                manager.scheduleDailyReminder()
            }
        }
    }

    private var streakSection: some View {
        HStack {
            Image(systemName: "flame.fill").foregroundColor(.orange)
            Text("Streak: \(manager.streak)")
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1)))
        .scaleEffect(streakScale)
        .onChange(of: manager.streak) { _ in
            withAnimation(.spring()) { streakScale = 1.3 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()) { streakScale = 1 }
            }
        }
    }

    private var xpSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("XP: \(manager.totalXP)")
                    .font(.headline)
                Spacer()
                Text("Level \(manager.level)")
                    .font(.subheadline)
            }
            ProgressView(value: Double(manager.dailyXP), total: Double(manager.dailyGoal))
                .tint(.blue)
            Text("Daily goal: \(manager.dailyXP)/\(manager.dailyGoal)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
    }

    private var heartsSection: some View {
        HStack(spacing: 4) {
            ForEach(0..<manager.maxHearts, id: .self) { idx in
                Image(systemName: idx < manager.hearts ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            Spacer()
            Button("Refill (10💎)") {
                _ = manager.manualRefillHeart()
            }
            .font(.caption)
            .disabled(manager.gems < 10)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.red.opacity(0.1)))
        .overlay(
            Group {
                if manager.hearts == 0 {
                    Text("No hearts left")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 36)
                }
            }, alignment: .bottom
        )
    }

    private var gemsSection: some View {
        HStack {
            Image(systemName: "diamond.fill").foregroundColor(.purple)
            Text("Gems: \(manager.gems)")
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.purple.opacity(0.1)))
    }

    private var lessonsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Lessons")
                .font(.headline)
            ForEach(manager.lessons) { lesson in
                HStack {
                    Text(lesson.title)
                    Spacer()
                    if lesson.isCompleted {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    } else if !lesson.isUnlocked {
                        Image(systemName: "lock.fill")
                    } else {
                        Button("Start") { manager.completeLesson(lesson) }
                            .disabled(manager.hearts == 0)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green.opacity(0.1)))
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Achievements")
                .font(.headline)
            ForEach(Achievement.allCases, id: \.self) { ach in
                HStack {
                    Text(ach.rawValue)
                    Spacer()
                    if manager.earnedAchievements.contains(ach) {
                        Image(systemName: "checkmark.seal.fill").foregroundColor(.green)
                    } else {
                        Image(systemName: "seal").foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.yellow.opacity(0.1)))
    }

    private var leaderboardSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Leaderboard")
                .font(.headline)
            ForEach(manager.leaderboard) { player in
                HStack {
                    Text(player.name)
                    Spacer()
                    Text("\(player.xp) XP")
                }
                .font(player.name == "You" ? .headline : .body)
                .foregroundColor(player.name == "You" ? .blue : .primary)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
    }

    private var friendsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Friends")
                    .font(.headline)
                Spacer()
                TextField("Add friend", text: $newFriendName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 120)
                Button("Add") {
                    guard !newFriendName.isEmpty else { return }
                    manager.addFriend(name: newFriendName)
                    newFriendName = ""
                }
            }
            ForEach(manager.friends) { friend in
                HStack {
                    Text(friend.name)
                    Spacer()
                    Text("🔥\(friend.streak)  \(friend.xp) XP")
                }
            }
            if manager.friends.isEmpty {
                Text("Connect with friends to see their progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1)))
    }
}

#Preview {
    GamificationView()
}
