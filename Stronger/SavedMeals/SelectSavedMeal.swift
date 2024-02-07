//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu
import SwiftUI

struct SelectSavedMeal: View {
    // replace with real data
    let mealData = MealData(mealItems: [MealItem(name: "Chicken Salad", size: "large", protein: 18),
        MealItem(name: "Garlic Breadsticks", size: "medium", protein: 12),
        MealItem(name: "Cheese Stick", size: "small", protein: 7),
        MealItem(name: "Glass of Milk", size: "medium", protein: 8),
        MealItem(name: "Chocolate Chip Cookie", size: "small", protein: 2)])
    var body: some View {
        VStack {
            Text("Please select which saved meal to log")
                .font(.title2)
                .bold()
                .padding()
                .multilineTextAlignment(.center)
            
            Divider() // can make bolder like SelectNeworSaved
            
            // Vertically stacked buttons for meal options
            // Do we want to make the number of buttons variable?
            NavigationLink(destination: EditSavedMeal(mealData: mealData)) {
                Text("1. Lunch 02/05/2024")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 2))
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            NavigationLink(destination: EditSavedMeal(mealData: mealData)) {
                Text("2. Dinner 02/04/2024")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 2))
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            NavigationLink(destination: EditSavedMeal(mealData: mealData)) {
                Text("3. Lunch 02/03/2024")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 2))
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            NavigationLink(destination: EditSavedMeal(mealData: mealData)) {
                Text("4. Breakfast 02/03/2024")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 2))
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            NavigationLink(destination: EditSavedMeal(mealData: mealData)) {
                Text("5. Dinner 02/02/2024")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 2))
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            .navigationTitle("Select Saved Meal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
    
    #Preview {
        SelectSavedMeal()
    }
