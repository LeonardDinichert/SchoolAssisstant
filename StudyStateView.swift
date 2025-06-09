import SwiftUI

struct StudyStateView: View {
    @Binding var show: Bool
    @State private var studyState: String = "Middle School"
    private let studyOptions = ["Middle School", "High School", "College", "University", "Other"]
    @StateObject private var viewModel = userManagerViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Where do you study?")
                    .font(.title2)
                    .fontWeight(.semibold)

                Picker("Study State", selection: $studyState) {
                    ForEach(studyOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)

                Button("Save") {
                    Task {
                        try? await viewModel.updateStudyState(state: studyState)
                        show = false
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .onAppear {
                Task { try? await viewModel.loadCurrentUser() }
            }
        }
    }
}

#Preview {
    StudyStateView(show: .constant(true))
}
