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
            
            Text("Did you learn something new ?")
            
            Button {
                userWantsAddInfo = true
            } label: {
                Text("I learned something new i want to remember")
            }
            
            Button {
                userWantsToRevise = true
            } label: {
                Text("I want to revise")
            }

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
