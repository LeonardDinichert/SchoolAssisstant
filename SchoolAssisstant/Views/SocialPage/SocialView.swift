import SwiftUI

struct SocialView: View {
    @StateObject private var viewModel = userManagerViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.leaderboard, id: \.userId) { friend in
                    if friend.userId != viewModel.user?.userId {
                        VStack(alignment: .leading) {
                            Text(friend.username ?? "Unknown")
                                .font(.headline)
                            if let last = friend.lastConnection {
                                Text("Last online: \(last, style: .relative)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Social")
            .onAppear {
                Task {
                    try? await viewModel.loadCurrentUser()
                    await viewModel.loadLeaderboard()
                }
            }
        }
    }
}

#Preview {
    SocialView()
}
