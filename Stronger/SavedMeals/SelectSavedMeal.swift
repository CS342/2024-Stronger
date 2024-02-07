//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu
import SwiftUI

struct SelectSavedMeal: View {
    let mealData = MealData(mealItems: [
        MealItem(name: "Chicken Salad", size: "large", protein: 18),
        MealItem(name: "Garlic Breadsticks", size: "medium", protein: 12),
        MealItem(name: "Cheese Stick", size: "small", protein: 7),
        MealItem(name: "Glass of Milk", size: "medium", protein: 8),
        MealItem(name: "Chocolate Chip Cookie", size: "small", protein: 2)
    ])

    var body: some View {
        VStack {
            headerText
            Divider()
            mealOptionLinks
        }
        .navigationTitle("Select Saved Meal")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerText: some View {
        Text("Please select which saved meal to log")
            .font(.title2)
            .bold()
            .padding()
            .multilineTextAlignment(.center)
    }

    private var mealOptionLinks: some View {
        ForEach(mealData.mealItems.indices, id: \.self) { index in
            mealOptionButton(for: mealData.mealItems[index], index: index)
        }
    }

    private func mealOptionButton(for meal: MealItem, index: Int) -> some View {
        NavigationLink(destination: EditSavedMeal(mealData: mealData)) {
            Text("\(index + 1). \(meal.name)")
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 2))
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}

// preview
struct SelectSavedMeal_Previews: PreviewProvider {
    static var previews: some View {
        SelectSavedMeal()
    }
}
