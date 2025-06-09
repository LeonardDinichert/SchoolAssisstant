//
//  IntroPagesModel.swift
//  SchoolAssisstant
//
//  Created by OpenAI on 2025.
//

import Foundation

struct IntroPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
}

struct IntroPagesModel {
    static let pages: [IntroPage] = [
        IntroPage(title: "Welcome", description: "School Assistant helps you learn anything faster and have fun doing it.", systemImage: "books.vertical"),
        IntroPage(title: "Democratize Learning", description: "Our goal is to democratize knowledge and make studying simpler for everyone.", systemImage: "bolt.fill"),
        IntroPage(title: "Disclaimer", description: "An app can't replace a real teacher but it will help you learn with ease.", systemImage: "exclamationmark.triangle")
    ]
}

