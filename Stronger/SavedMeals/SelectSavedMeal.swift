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
        MealItem(name: "Chicken Salad", size: "large portion", protein: 18, imageName: "chickenSalad"),
        MealItem(name: "Garlic Breadsticks", size: "medium portion", protein: 12, imageName: "garlicBreadsticks"),
        MealItem(name: "Cheese Stick", size: "small portion", protein: 7, imageName: "cheeseStick"),
        MealItem(name: "Glass of Milk", size: "medium portion", protein: 8, imageName: "glassOfMilk"),
        MealItem(name: "Chocolate Chip Cookie", size: "small portion", protein: 2, imageName: "chocolateChipCookie")
    ])

    private var mealTitles: [String] {
        [
            "1. Lunch 02/05/2024",
            "2. Dinner 02/04/2024",
            "3. Lunch 02/03/2024",
            "4. Breakfast 02/03/2024",
            "5. Dinner 02/02/2024"
        ]
    }

    var body: some View {
        VStack {
            Text("Please select which saved meal to log")
                .font(.title2)
                .bold()
                .padding()
                .multilineTextAlignment(.center)
            Divider()
            mealOptionsSection
        }
        .navigationTitle("Select Saved Meal")
        .navigationBarTitleDisplayMode(.inline)
    }


    private var mealOptionsSection: some View {
        ForEach(Array(mealTitles.enumerated()), id: \.offset) { index, title in
            mealOptionLink(title: title, index: index)
        }
    }

    private func mealOptionLink(title: String, index: Int) -> some View {
        NavigationLink(destination: EditSavedMeal(mealData: mealData)) {
            Text(title)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 2))
        }
        .padding(.horizontal)
        .padding(.bottom, 5)
    }
}

// Preview
struct SelectSavedMeal_Previews: PreviewProvider {
    static var previews: some View {
        SelectSavedMeal()
    }
}
