//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu

import SwiftUI

struct EditSavedMealContents: View {
    @ObservedObject var mealData: MealData
    var mealIndex: Int
    
    @State private var selectedSize: String
    @State private var newProteinContent: String = ""
    
    init(mealData: MealData, mealIndex: Int) {
        self.mealData = mealData
        self.mealIndex = mealIndex
        _selectedSize = State(initialValue: mealData.mealItems[mealIndex].size)
    }
    
    var body: some View {
        VStack {
            // Placeholder image for food
            Rectangle()
                .fill(Color.gray)
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(Text("Food Image Placeholder"))
                .foregroundColor(.black)
            
            // Option to change the food
            NavigationLink(destination: ChangeFoodOptions(mealData: mealData, mealIndex: mealIndex)) {
                Text("Change Food")
            }
            
            // Dropdown for portion size
            Picker("Change Portion Size", selection: $selectedSize) {
                Text("Large Meal").tag("large meal")
                Text("Medium Meal").tag("medium meal")
                Text("Small Meal").tag("small meal")
            }
            .pickerStyle(MenuPickerStyle())
            
            // Input for protein content
            HStack {
                Text("Change Protein Content")
                TextField("Protein Content", text: $newProteinContent)
                    .keyboardType(.numberPad)
            }
            
            // Save Button
            Button("Save Changes") {
                // Perform input validation and updating of the meal data
                if let index = mealData.mealItems.firstIndex(where: { $0.id == mealData.mealItems[mealIndex].id }),
                   !newProteinContent.isEmpty,
                   let newProtein = Int(newProteinContent), !newProteinContent.isEmpty {
                       mealData.mealItems[mealIndex].size = selectedSize
                       mealData.mealItems[mealIndex].protein = newProtein
                }
            }
            
            Spacer()
        }
        .navigationTitle("Edit Meal Content")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChangeFoodOptions: View {
    @ObservedObject var mealData: MealData
    var mealIndex: Int
    
    var body: some View {
        Text("Food Change Options")
    }
}

// Preview
struct EditSavedMealContents_Previews: PreviewProvider {
    static var previews: some View {
        let mealData = MealData(mealItems: [
            MealItem(name: "Chicken Salad", size: "large", protein: 18),
            MealItem(name: "Garlic Breadsticks", size: "medium", protein: 12),
            MealItem(name: "Cheese Stick", size: "small", protein: 7),
            MealItem(name: "Glass of Milk", size: "medium", protein: 8),
            MealItem(name: "Chocolate Chip Cookie", size: "small", protein: 2)])
        }
}
