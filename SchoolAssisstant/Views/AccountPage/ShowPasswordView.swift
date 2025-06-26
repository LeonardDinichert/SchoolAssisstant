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
                Text("Reset my password")
            }
            .primaryButtonStyle()
            .padding(.leading)
            Spacer()
        }
        .background(AppTheme.background)
    }
}

struct ShowPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ShowPasswordView()
    }
}
