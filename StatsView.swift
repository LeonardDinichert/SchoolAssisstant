import SwiftUI
import Charts
import FirebaseAuth
import FirebaseFirestoreSwift

struct StudySession: Identifiable, Codable {
    @DocumentID var id: String?
    let session_start: Date
    let session_end: Date
    let studied_subject: String

    var duration: TimeInterval {
        session_end.timeIntervalSince(session_start)
    }
}

@MainActor
final class StatsViewModel: ObservableObject {
    @Published var sessions: [StudySession] = []

    func load() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        do {
            sessions = try await UserManager.shared.fetchStudySessions(userId: userId)
        } catch {
            print("Failed to load sessions: \(error)")
        }
    }

    var dailyTotals: [(day: Date, minutes: Double)] {
        let cal = Calendar.current
        var totals: [Date: Double] = [:]
        for s in sessions {
            let day = cal.startOfDay(for: s.session_start)
            totals[day, default: 0] += s.duration / 60
        }
        return totals.map { ($0.key, $0.value) }.sorted { $0.day < $1.day }
    }

    var streak: Int {
        let cal = Calendar.current
        let days = Set(sessions.map { cal.startOfDay(for: $0.session_start) }).sorted(by: >)
        guard let first = days.first else { return 0 }
        var count = 1
        var prev = first
        for day in days.dropFirst() {
            if cal.dateComponents([.day], from: day, to: prev).day == 1 {
                count += 1
                prev = day
            } else if day == prev {
                continue
            } else {
                break
            }
        }
        return count
    }
}

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.dailyTotals.isEmpty {
                    Text("No sessions yet")
                        .foregroundColor(.secondary)
                } else {
                    Chart {
                        ForEach(viewModel.dailyTotals, id: \.day) { entry in
                            BarMark(
                                x: .value("Day", entry.day, unit: .day),
                                y: .value("Minutes", entry.minutes)
                            )
                            .foregroundStyle(AppTheme.primaryColor)
                        }
                    }
                    .frame(height: 200)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Stats")
            .onAppear { Task { await viewModel.load() } }
        }
    }
}

#Preview {
    StatsView()
}
