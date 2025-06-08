//
//  EmailSignInPageView.swift.swift
//  TOD
//
//  Created by Léonard Dinichert on 08.07.23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import FirebaseCore

struct LogInView: View {
    
    @StateObject private var viewModel = SignUpEmailViewModel()
    @StateObject private var googleVm = SignInWithGoogleModel()
    @ObservedObject var appleVM = AppleSignInViewModel()
    
    @AppStorage("showSignInView") private var showSignInView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Welcoming Header
                    VStack(spacing: 8) {
                        Text("Welcome Back to Jobb")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        Text("Log in to access your account.")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 40)
                    
                    // Email Field Card
                    CustomTextField(text: $viewModel.email, placeholder: "Email", keyboardType: .emailAddress, returnKeyType: .next)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    
                    // Password Field Card
                    CustomTextField(text: $viewModel.password, placeholder: "Password", isSecure: true, returnKeyType: .done)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    // Primary Login Button
                    Button(action: {
                        Task {
                            viewModel.errorMessage = ""
                            await signInWithEmail()
                            if viewModel.errorMessage == "" {
                                showSignInView = false
                            }
                        }
                    }) {
                        Text("Log in")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill((viewModel.email.isEmpty || viewModel.password.isEmpty) ? Color.gray : Color.blue)
                            )
                            .padding(.horizontal)
                    }
                    .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                    
                    // Social Sign-In Buttons
                    Button(action: {
                        Task { await signInWithGoogle() }
                    }) {
                        HStack(spacing: 12) {
                            Image("google")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Log in with Google")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    }
                    
                    Button {
                        Task { await signUpWithApple() }
                    } label: {
                        SignInWithAppleButtonViewRepresentable(type: .signIn, style: .black)
                    }
                    .frame(height: 50)
                    .padding(.horizontal)
                    .onChange(of: appleVM.didSignInWithApple) { _, newValue in
                        if newValue { showSignInView = false }
                    }
                    
                    // Navigation Links for Sign Up and Reset Password
                    NavigationLink(destination: SignUpView().navigationBarBackButtonHidden()) {
                        HStack {
                            Text("Don't have an account yet?")
                            Text("Sign up")
                                .bold()
                                .foregroundColor(Color.blue)
                        }
                        .font(.subheadline)
                        .padding()
                    }
                    
//                    NavigationLink(destination: ResetPasswordView().navigationBarBackButtonHidden()) {
//                        Text("Forgot your password?")
//                            .bold()
//                            .underline()
//                            .foregroundColor(Color("JobbGreen"))
//                            .font(.subheadline)
//                            .padding()
//                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    func signInWithEmail() async {
        do {
            viewModel.signIn()
        }
    }
    
    func signInWithGoogle() async {
        do {
            try await googleVm.signInGoogle()
            print("done")
            self.showSignInView = false
            print("double done", self.showSignInView, showSignInView)
            
        } catch {
            print("Error signing in with Google: \(error)")
        }
    }
    
    func signUpWithApple() async {
        
        appleVM.signUpWithApple()
        showSignInView = false
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
