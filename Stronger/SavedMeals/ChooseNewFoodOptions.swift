//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu

import SwiftUI

struct ChooseNewFoodOptions: View {
    @Binding var selectedMealItem: MealItem

    var body: some View {
        VStack {
            Text("How do you want to change your food option?")
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
            // change destination later to chat
            NavigationLink(destination: MealReport()) {
                Text("Input New Food to Chat")
                    .foregroundColor(.black)
                    .font(.headline) // can incease size
                    .padding(.vertical, 20)
                    .padding(.horizontal, 40)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange, lineWidth: 2))
            }.padding(.bottom, 70)
            
            NavigationLink(destination: CommonlySavedItems(selectedItem: $selectedMealItem)) {
                    Text("Choose From Your Common foods")
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


// #Preview {
//     ChooseNewFoodOptions()
// }
