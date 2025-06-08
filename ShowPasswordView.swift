//
//  ShowPasswordView.swift
//  
//
//  Created by Léonard Dinichert on 10.04.25.
//

import SwiftUI

struct ShowPasswordView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Modify my password")
                    .font(.title3)
                    .foregroundColor(.primary)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.leading)
            
            NavigationLink {
                ResetPasswordView()
            } label: {
                ZStack {
                    
                    Rectangle()
                        .frame(width: 160, height: 40)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .foregroundColor(.white)
                    Text("Reset my password")
                        .font(.title3)
                        .foregroundColor(.primary)
                        .fontWeight(.medium)
                }
            }
           .padding(.leading)
            Spacer()
        }
    }
}

struct ShowPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ShowPasswordView()
    }
}
