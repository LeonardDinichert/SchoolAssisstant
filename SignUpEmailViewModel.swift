//
//  EmailViewModel.swift
//  Jobb
//
//  Created by Léonard Dinichert on 10.07.23.
//

import SwiftUI
import CryptoKit
import AuthenticationServices

@MainActor
final class SignUpEmailViewModel: NSObject, ObservableObject, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }
        return window
    }
    
    @AppStorage("showSignInView") private var showSignInView: Bool = true
    
    @Published var email : String = ""
    @Published var password : String = ""
    @State var appleVM = AppleSignInViewModel()
    @Published var errorMessage = ""

        
    func signUp() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            self.errorMessage = "The email or the password misses"
            return
        }
        
        Task {
            do {
                let authDataResult = try await AuthService.shared.createUser(email: email, password: password)
                let user = DBUser(auth: authDataResult)
                try UserManager.shared.createNewUser(user: user)
                
                print("Success")
                print(errorMessage)
                
            } catch {
                print("Error \(error)")
                self.errorMessage = "\(error.localizedDescription)"
            }
        }
    }
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            self.errorMessage = "No email or password found."

            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthService.shared.signInUser(email: email, password: password)
                print("Success")
                print(returnedUserData)
            } catch {
                print("Error \(error)")
                self.errorMessage = "\(error.localizedDescription)"

            }
        }
    }
}
