//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu


import SwiftUI

struct ChangeFoodOptions: View {
    @ObservedObject var mealData: MealData
    var mealIndex: Int
    
    var body: some View {
        Text("Food Change Options")
    }
}

struct EditSavedMealContents: View {
    @ObservedObject var mealData: MealData
    var mealIndex: Int
    
    @State private var selectedSize: String
    @State private var newProteinContent: String = ""
    
    var body: some View {
        VStack {
            placeholderImage
            changeFoodOptionLink
            portionSizePicker
            proteinContentInput
            saveChangesButton
            Spacer()
        }
        .navigationTitle("Edit Meal Content")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray)
            .aspectRatio(16 / 9, contentMode: .fit)
            .overlay(Text("Food Image Placeholder"))
            .foregroundColor(.black)
    }
    
    private var changeFoodOptionLink: some View {
        NavigationLink(destination: ChangeFoodOptions(mealData: mealData, mealIndex: mealIndex)) {
            Text("Change Food")
        }
    }
    
    private var portionSizePicker: some View {
        Picker("Change Portion Size", selection: $selectedSize) {
            Text("Large Meal").tag("large meal")
            Text("Medium Meal").tag("medium meal")
            Text("Small Meal").tag("small meal")
        }
        .pickerStyle(MenuPickerStyle())
    }
    
    private var proteinContentInput: some View {
        HStack {
            Text("Change Protein Content")
            TextField("Protein Content", text: $newProteinContent)
                .keyboardType(.numberPad)
        }
    }
    
    private var saveChangesButton: some View {
        Button("Save Changes") {
            if let index = mealData.mealItems.firstIndex(where: { $0.id == mealData.mealItems[mealIndex].id }),
               !newProteinContent.isEmpty,
               let newProtein = Int(newProteinContent) {
                mealData.mealItems[mealIndex].size = selectedSize
                mealData.mealItems[mealIndex].protein = newProtein
            }
        }
    }
}
