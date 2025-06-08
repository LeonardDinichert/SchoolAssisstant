//
//  userManager.swift
//
//
//  Created by Léonard Dinichert on 10.04.25.
//

import Foundation
import FirebaseFirestore
import PhotosUI
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseMessaging

struct DBUser: Codable {
    // MARK: - Properties
    
    let userId: String
    let email: String?
    let age: Int?
    let username: String?
    let firstName: String?
    let lastName: String?
    let profileImagePathUrl: String?
    let biography: String?
    var fcmToken: String?
    
    // MARK: - Initializers
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.age = nil
        self.firstName = nil
        self.lastName = nil
        self.username = nil
        self.profileImagePathUrl = nil
        self.biography = nil
        self.fcmToken = nil
    }
    
    init(
        userId: String,
        email: String? = nil,
        age: Int? = nil,
        username: String? = nil,
        preferences: [String]? = nil,
        firstName: String? = nil,
        lastName: String? = nil,
        profileImagePathUrl: String? = nil,
        biography: String? = nil,
        fcmToken: String? = nil
    ) {
        self.userId = userId
        self.email = email
        self.age = age
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.profileImagePathUrl = profileImagePathUrl
        self.biography = biography
        self.fcmToken = fcmToken
    }
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case age = "age"
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case profileImagePathUrl = "profile_image_path_url"
        case biography = "biography"
        case fcmToken = "fcmToken" // Coding Key for FCM Token
    }
    
    // MARK: - Decoder Initializer
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.age = try container.decodeIfPresent(Int.self, forKey: .age)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
        self.biography = try container.decodeIfPresent(String.self, forKey: .biography)
        self.fcmToken = try container.decodeIfPresent(String.self, forKey: .fcmToken) // Decode FCM Token
    }
    
    // MARK: - Encoder Method
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.username, forKey: .username)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.age, forKey: .age)
        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
        try container.encodeIfPresent(self.biography, forKey: .biography)
        try container.encodeIfPresent(self.fcmToken, forKey: .fcmToken) // Encode FCM Token
    }
}

final class UserManager: ObservableObject {
    
    // MARK: - Singleton Instance
    
    static let shared = UserManager()
    private init() {}
    
    // MARK: - Firestore References
    
    let userCollection = Firestore.firestore().collection("users")
    
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    // MARK: - Firestore Encoder/Decoder
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        // encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    // MARK: - Authentication Properties
    
    @Published var currentUser: DBUser? = nil
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Firestore User Data Management
    
    func createNewUser(user: DBUser) throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func deleteUsersData(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func getAllUsers() async throws -> [DBUser] {
        let querySnapshot = try await userCollection.getDocuments()
        return try querySnapshot.documents.compactMap { document in
            try document.data(as: DBUser.self)
        }
    }
    
    func updateUserInfo(userId: String, firstName: String, lastName: String, birthDate: Date, username: String) async throws {
        let data: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "username": username,
            "birthdate": birthDate,
        ]
        
        try await userDocument(userId: userId).setData(data, merge: true)
    }
    
    func updateUserAdress(userId: String, adress: String) async throws {
        let data: [String: Any] = [
            "adress": adress
        ]
        
        try await userDocument(userId: userId).setData(data, merge: true)
    }
    
    func addStudySessionRegisteredToUser(userId: String, studiedSubject: String, start: Date, end: Date) async throws {
        let data: [String: Any] = [
            "id": userId,
            "session_start": start,
            "session_end": end,
            "studied_subject": studiedSubject
        ]
        
        try await userDocument(userId: userId).collection("work_sessions").addDocument(data: data)
    }
    
    func addBiographyAndTownToUser(userId: String, biography: String, town : String) async throws {
        let data: [String: Any] = [
            "biography": biography,
            "town" : town
        ]
        
        try await userDocument(userId: userId).setData(data, merge: true)
    }
    
    func modifyBiographyToUser(userId: String, biography: String) async throws {
        let data: [String: Any] = [
            "biography": biography,
        ]
        
        try await userDocument(userId: userId).setData(data, merge: true)
    }
    
    func loadCurrentUserId() async throws -> String {
        
        let userId = Auth.auth().currentUser?.uid ?? "none"
        return userId
    }
    
    func updateUserProfileImagePathUrl(userId: String, path: String?, url: String?) async throws {
        let data: [String: Any] = [
            DBUser.CodingKeys.profileImagePathUrl.rawValue: url ?? "no path",
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func saveFCMTokenToFirestore(token: String, userId: String) {
        
        print("FCM Token: \(token)")
        self.userDocument(userId: userId).updateData([
            "fcmToken": token
        ]) { error in
            if let error = error {
                print("Error saving FCM token to Firestore: \(error)")
            } else {
                print("FCM token successfully saved to Firestore")
            }
        }
    }
}

// MARK: - userManagerViewModel

@MainActor
final class userManagerViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    let userCollection = Firestore.firestore().collection("users")
    
    func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func loadCurrentUser() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user.")
            return
        }
        
        print("userid", userId)

        self.user = try await UserManager.shared.getUser(userId: userId)
    }
    
    func sendNotificationRequest(title: String, body: String) {
        guard let url = URL(string: "https://us-central1-jobb-8f5e7.cloudfunctions.net/sendPushNotification") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Retrieve the FCM token from UserManager
        guard let fcmToken = user?.fcmToken else {
            print("FCM token not found (userManagerViewModel sendNotificationRequest)")
            return
        }

        let bodyData: [String: Any] = [
            "token": fcmToken,
            "title": title,
            "body": body
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: bodyData, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending notification request: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Notification request sent successfully")
                } else {
                    print("Server error: \(httpResponse.statusCode)")
                    if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                        print("Error message: \(errorMessage)")
                    }
                }
            }
        }
        task.resume()
    }
    
    func saveProfileImage(data: Data, userId: String) async throws {
        let (path, name) = try await StorageManager.shared.saveImage(data: data, userId: userId)
        print("SUCCESS in saving image!")
        print("Path: \(path)")
        print("Name: \(name)")
        let url = try await StorageManager.shared.getUrlForImage(path: path)
        try await UserManager.shared.updateUserProfileImagePathUrl(userId: userId, path: path, url: url.absoluteString)
    }
    
    func deleteProfileImage() {
        guard let user = user, let path = user.profileImagePathUrl else { return }
        
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePathUrl(userId: user.userId, path: nil, url: nil)
        }
    }
}

