//
//  UserWantsToAddInfoView.swift
//  SchoolAssisstant
//
//  Created by Léonard Dinichert on 26.05.2025.
//

import SwiftUI

struct UserWantsToAddInfoView: View {
    
    @State private var category: String = ""
    @State private var learned: String = ""
    enum Importance: String, CaseIterable, Identifiable {
        case low = "Low", medium = "Medium", high = "High"
        var id: String { rawValue }
    }
    @State private var importance: Importance = .low
    @Binding var userWantsAddInfo: Bool


    var body: some View {
        VStack(spacing: 32) {
            Text("Add New Info")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 24) {
                Group {
                    Text("Category")
                        .font(.headline)
                    TextField("What category does it fit in?", text: $category)
                        .textFieldStyle(.roundedBorder)
                }

                Group {
                    Text("What did you learn specifically?")
                        .font(.headline)
                    TextField("Describe what you learned", text: $learned)
                        .textFieldStyle(.roundedBorder)
                }

                Group {
                    Text("How important is it?")
                        .font(.headline)
                    Picker("Importance", selection: $importance) {
                        ForEach(Importance.allCases) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)

            Button(action: {
                // TODO: handle save action
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                userWantsAddInfo = false
            } label: {
                Text("Back")
            }
            .buttonStyle(.borderless)


            Spacer()
        }
        .padding()
    }
    
    func save() {
        
        
        
        userWantsAddInfo = false

    }
}

#Preview {
    UserWantsToAddInfoView(userWantsAddInfo: .constant(true))
}
