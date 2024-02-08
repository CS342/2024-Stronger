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
    var imageName: String
}

struct MealItemView: View {
    @Binding var mealItem: MealItem
    var mealData: MealData

    var body: some View {
        NavigationLink(destination:
                EditSavedMealContents(mealData: mealData, mealIndex: mealData.mealItems.firstIndex(where: { $0.id == mealItem.id }) ?? 0)) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(mealItem.name)
                        .bold()
                        .foregroundColor(.black)
                    Text("You indicated: \(mealItem.size)")
                        .foregroundColor(.black)
                    Text("[\(mealItem.protein)] grams of protein")
                        .foregroundColor(.black)
                }
                Spacer()
                // Display the image
                Image(mealItem.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .accessibilityLabel("meal picture")
            }
            .padding()
            Divider()
        }
    }
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
            MealItemView(mealItem: $mealData.mealItems[index], mealData: mealData)
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
// preview
struct EditSavedMeal_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMeals = [
            MealItem(name: "Chicken Salad", size: "large portion", protein: 18, imageName: "chickenSalad"),
            MealItem(name: "Garlic Breadsticks", size: "medium portion", protein: 12, imageName: "garlicBreadsticks"),
            MealItem(name: "Cheese Stick", size: "small portion", protein: 7, imageName: "cheeseStick"),
            MealItem(name: "Glass of Milk", size: "medium portion", protein: 8, imageName: "glassOfMilk"),
            MealItem(name: "Chocolate Chip Cookie", size: "small portion", protein: 2, imageName: "chocolateChipCookie")
        ]
        let mealData = MealData(mealItems: sampleMeals)
        return NavigationView {
            EditSavedMeal(mealData: mealData)
        }
    }
}
