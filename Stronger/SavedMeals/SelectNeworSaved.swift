// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu
import SwiftUI

struct SelectNeworSaved: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Are you logging a new or saved meal?")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                // Custom Divider
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.gray)
                    .padding(.vertical)
                Spacer()
                Button(action: {
                    // placeholder action
                    print("New Meal")
                }) {
                    Text("New Meal")
                        .foregroundColor(.black)
                        .font(.headline) // can increase size
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange, lineWidth: 2))
                } .padding(.bottom, 70)
                NavigationLink(destination: SelectSavedMeal()) {
                    Text("Saved Meal")
                        .foregroundColor(.black)
                        .font(.headline) // can incease size
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.orange, lineWidth: 2))
                }
                Spacer()
            }
        }
    }
}

#Preview {
    SelectNeworSaved()
}
