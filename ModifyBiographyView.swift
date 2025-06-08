//
//  modifyBiographyView.swift
//  Jobb
//
//  Created by Léonard Dinichert on 10.04.2025.
//

import SwiftUI

struct modifyBiographyView: View {
    
    let userId: String
    @State private var biography: String = ""
       
       var body: some View {
           NavigationStack {
               VStack {
                   // Header Section
                   VStack(spacing: 8) {
                       Text("Edit Your Biography")
                           .font(.largeTitle)
                           .fontWeight(.bold)
                           .foregroundColor(.primary)
                           .multilineTextAlignment(.center)
                       
                       Text("Share your story, skills, and experiences so others can get to know you better.")
                           .font(.subheadline)
                           .foregroundColor(.secondary)
                           .multilineTextAlignment(.center)
                           .padding(.horizontal, 30)
                   }
                   .padding(.top, 40)
                   
                   // Biography Editor
                   TextEditor(text: $biography)
                       .font(.body)
                       .padding(12)
                       .frame(minHeight: 150, maxHeight: 300)
                       .background(
                           RoundedRectangle(cornerRadius: 12)
                               .fill(Color.white)
                               .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                       )
                       .padding(.horizontal)
                       .padding(.top, 20)
                   
                   Spacer()
                   
                   // Save Button
                   Button(action: {
                       Task {
                           try await UserManager.shared.modifyBiographyToUser(userId: userId, biography: biography)
                       }
                   }) {
                       Text("Save Biography")
                           .font(.headline)
                           .fontWeight(.semibold)
                           .foregroundColor(.white)
                           .frame(maxWidth: .infinity)
                           .padding()
                           .background(
                               RoundedRectangle(cornerRadius: 12)
                                   .fill(Color("JobbGreen"))
                           )
                   }
                   .padding(.horizontal)
                   .padding(.bottom, 20)
               }
               .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
               .navigationTitle("Edit Biography")
               .navigationBarTitleDisplayMode(.inline)
           }
       }
}

#Preview {
    modifyBiographyView(userId: "")
}
