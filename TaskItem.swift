import Foundation
import FirebaseFirestoreSwift

struct TaskItem: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var dueDate: Date
    var completed: Bool
    var createdAt: Date
}
