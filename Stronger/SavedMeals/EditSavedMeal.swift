//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu
import SwiftUI

class MealData: ObservableObject {
    @Published var mealItems: [MealItem]
    
    init(mealItems: [MealItem]) {
        self.mealItems = mealItems
    }
}

struct MealItem: Identifiable {
    let id = UUID()
    var name: String
    var size: String
    var protein: Int
}

struct EditSavedMeal: View {
    @ObservedObject var mealData: MealData
    
    var body: some View {
        VStack {
            mealList
            navigationToMealReport
        }
        .navigationTitle("Edit Saved Meal")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var mealList: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                Divider()
                mealItemsView
            }
        }
    }
    
    private var header: some View {
        VStack(alignment: .leading) {
            Text("Lunch 02/05/2024")
                .font(.title)
                .bold()
                .padding(.top)
                .padding(.leading)
            
            Text("Click an item image to edit or next to continue")
                .font(.subheadline)
                .padding(.bottom)
                .padding(.leading)
        }
    }
    
    private var mealItemsView: some View {
        ForEach(mealData.mealItems.indices, id: \.self) { index in
            MealItemView(mealItem: $mealData.mealItems[index])
        }
    }
    
    private var navigationToMealReport: some View {
        NavigationLink(destination: MealReport()) {
            Text("Next")
                .foregroundColor(.black)
                .font(.headline)
                .padding(.vertical, 10)
                .padding(.horizontal, 40)
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange, lineWidth: 2))
        }
    }
}

// Meal Items subview
struct MealItemView: View {
    @Binding var mealItem: MealItem
    
    var body: some View {
        NavigationLink(destination: ChooseNewFoodOptions(selectedMealItem: $mealItem)) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(mealItem.name)")
                        .bold()
                        .foregroundColor(.black)
                    Text("You indicated: \(mealItem.size)")
                        .foregroundColor(.black)
                    Text("[\(mealItem.protein)] grams of protein")
                        .foregroundColor(.black)
                }
                Spacer()
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 80, height: 80)
                    .overlay(Text("Food Image"))
                    .foregroundColor(.black)
            }
            .padding()
            Divider()
        }
    }
}
