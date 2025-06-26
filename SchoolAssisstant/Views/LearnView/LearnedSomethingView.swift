//
//  LearnedSomethingView.swift
//  SchoolAssisstant
//
//  Created by Léonard Dinichert on 27.04.2025.
//

import SwiftUI

struct LearnedSomethingView: View {
    @State private var learned = ""
    @State private var userWantsToRevise = false
    @State private var userWantsAddInfo = false

    var body: some View {
        ZStack {
            // Full-screen background
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Header card
                VStack(spacing: 8) {
                    Text("Did you learn something new?")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("Share it or revise past notes below.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .shadow(radius: 4)
                )
                .padding(.horizontal)

                Spacer()

                // Action buttons
                VStack(spacing: 16) {
                    Button(action: { userWantsAddInfo = true }) {
                        Label("I learned something new", systemImage: "lightbulb.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: { userWantsToRevise = true }) {
                        Label("I want to revise", systemImage: "book.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        // Modals
        .fullScreenCover(isPresented: $userWantsAddInfo) {
            UserWantsToAddInfoView(userWantsAddInfo: $userWantsAddInfo)
        }
        .fullScreenCover(isPresented: $userWantsToRevise) {
            UserWantsToReviseView()
        }
    }
}
