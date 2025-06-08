import Foundation
import FirebaseFirestoreSwift

struct LearningNote: Codable, Identifiable {
    @DocumentID var id: String?
    let category: String
    let text: String
    let importance: String
    var reviewCount: Int
    var nextReview: Date
    let createdAt: Date
}
