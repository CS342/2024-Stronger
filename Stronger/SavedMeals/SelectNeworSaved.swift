// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu
import SwiftUI

struct SelectNeworSaved: View {
    private var greeting: String {
        "Are you logging a new or saved meal?"
    }

    var body: some View {
        VStack {
            Text(greeting) // Use the computed property
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            customDivider
            
            Spacer()
            
            newMealButton
            
            savedMealButton
            
            Spacer()
        }
    }

    private var customDivider: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.gray)
            .padding(.vertical)
    }
    
    private var newMealButton: some View {
        // Change this to navigate to Chatbot
        NavigationLink(destination: SelectSavedMeal()) {
            Text("New Meal")
                .foregroundColor(.black)
                .font(.headline)
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange, lineWidth: 2))
        }
    }
    
    private var savedMealButton: some View {
        NavigationLink(destination: SelectSavedMeal()) {
            Text("Saved Meal")
                .foregroundColor(.black)
                .font(.headline)
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange, lineWidth: 2))
        }
    }
}
// Preview
struct SelectNeworSaved_Previews: PreviewProvider {
    static var previews: some View {
        SelectNeworSaved()
    }
}
