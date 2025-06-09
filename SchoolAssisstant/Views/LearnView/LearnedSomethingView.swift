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
            .primaryButtonStyle()

            Button {
                userWantsToRevise = true
            } label: {
                Text("I want to revise")
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
        
            .fullScreenCover(isPresented: $userWantsAddInfo) {
                UserWantsToAddInfoView(userWantsAddInfo: $userWantsAddInfo)
            }
        
            .fullScreenCover(isPresented: $userWantsToRevise) {
                UserWantsToReviseView()
            }
        }
    }


#Preview {
    LearnedSomethingView()
}
