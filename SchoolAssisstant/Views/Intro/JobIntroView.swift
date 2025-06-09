//
//  JobIntroView.swift
//  SchoolAssisstant
//
//  Created by OpenAI on 2025.
//

import SwiftUI

struct JobIntroView: View {
    @AppStorage("hasShownWelcome") private var hasShownWelcome: Bool = false

    var body: some View {
        IntroPagesView(showIntro: $hasShownWelcome)
    }
}

#Preview {
    JobIntroView()
}

