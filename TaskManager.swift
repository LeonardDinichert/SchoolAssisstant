import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TaskManager {
    static let shared = TaskManager()
    private init() {}

    private var userCollection: CollectionReference {
        Firestore.firestore().collection("users")
    }

    private func tasksCollection(userId: String) -> CollectionReference {
        userCollection.document(userId).collection("tasks")
    }

    func addTask(_ task: TaskItem, userId: String) async throws {
        try tasksCollection(userId: userId).addDocument(from: task)
    }

    func fetchTasks(userId: String) async throws -> [TaskItem] {
        let snapshot = try await tasksCollection(userId: userId).getDocuments()
        return try snapshot.documents.compactMap { document in
            try document.data(as: TaskItem.self)
        }
    }

    func updateTask(_ task: TaskItem, userId: String) async throws {
        guard let id = task.id else { return }
        try tasksCollection(userId: userId).document(id).setData(from: task, merge: true)
    }

    func deleteTask(_ id: String, userId: String) async throws {
        try await tasksCollection(userId: userId).document(id).delete()
    }
}
