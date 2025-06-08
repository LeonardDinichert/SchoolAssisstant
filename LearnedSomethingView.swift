//
//  LearnedSomethingView.swift
//  SchoolAssisstant
//
//  Created by Léonard Dinichert on 27.04.2025.
//

import SwiftUI

struct LearnedSomethingView: View {
    
    @State var learned = ""
    @State var userWantsToRevise: Bool = false
    @State var userWantsAddInfo: Bool = false

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Did you learn something new?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Add your notes so you can review them later or open your revision list to check what\u2019s due today.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .cardStyle()

                Button {
                    userWantsAddInfo = true
                } label: {
                    Text("I learned something new I want to remember")
                }
                .primaryButtonStyle()

                Button {
                    userWantsToRevise = true
                } label: {
                    Text("I want to revise")
                }
                .primaryButtonStyle()

                Spacer()
            }
            .padding()
            .background(AppTheme.background)
        }
        .fullScreenCover(isPresented: $userWantsToRevise) {
            UserWantsToReviseView()
        }
        .fullScreenCover(isPresented: $userWantsAddInfo) {
            UserWantsToAddInfoView(userWantsAddInfo: $userWantsAddInfo)
        }
    }
}

#Preview {
    LearnedSomethingView()
}
