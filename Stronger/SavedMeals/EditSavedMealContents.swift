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
            changeFoodOptionLink
            portionSizePicker
            proteinContentInput
            saveChangesButton
            Spacer()
        }
        .navigationTitle("Edit Meal Content")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var changeFoodOptionLink: some View {
        NavigationLink(destination: ChooseNewFoodOptions(selectedMealItem: $mealData.mealItems[mealIndex])) {
            Text("Change Food")
        }
    }
    
    private var portionSizePicker: some View {
        Picker("Change Portion Size", selection: $selectedSize) {
            Text("Large portion").tag("large portion")
            Text("Medium portion").tag("medium portion")
            Text("Small portion").tag("small portion")
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
    init(mealData: MealData, mealIndex: Int, selectedSize: String? = nil) {
            self.mealData = mealData
            self.mealIndex = mealIndex
            _selectedSize = State(initialValue: selectedSize ?? mealData.mealItems[mealIndex].size)
    }
}
