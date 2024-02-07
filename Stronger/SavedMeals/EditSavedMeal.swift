//
//  EditSavedMeal.swift
//  Stronger
//
//  Created by Kevin Zhu on 2/5/24.
//

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
            ScrollView {
                VStack(alignment: .leading) {
                    // Header
                    Text("Lunch 02/05/2024")
                        .font(.title)
                        .bold()
                        .padding(.top)
                        .padding(.leading)
                    
                    Text("Click an item image to edit or next to continue")
                        .font(.subheadline)
                        .padding(.bottom)
                        .padding(.leading)
                    
                    Divider()
                    
                    // List of items
                    ForEach(mealData.mealItems.indices, id: \.self) { index in
                        NavigationLink(destination: ChooseNewFoodOptions(selectedMealItem: $mealData.mealItems[index])) {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(index + 1). \(mealData.mealItems[index].name)")
                                        .bold()
                                        .foregroundColor(.black)
                                    Text("You indicated: \(mealData.mealItems[index].size)")
                                        .foregroundColor(.black)
                                    Text("[\(mealData.mealItems[index].protein)] grams of protein")
                                        .foregroundColor(.black)
                                }
                            Spacer()
                            // Linking image to EditSavedMealContents
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 80, height: 80)
                                .overlay(Text("Food Image"))
                                .foregroundColor(.black)
                            }
                        }
                        .padding()
                        Divider()
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                NavigationLink(destination: MealReport()) {
                    Text("Next")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.orange, lineWidth: 2))
                }
                Spacer()
            }
            .padding(.bottom)
        }
        .navigationTitle("Edit Saved Meal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Preview
struct EditSavedMeal_Previews: PreviewProvider {
    static var previews: some View {
        // Sample data
        EditSavedMeal(mealData: MealData(mealItems: [
            MealItem(name: "Chicken Salad", size: "large meal", protein: 18),
            MealItem(name: "Garlic Breadsticks", size: "medium meal", protein: 12),
            MealItem(name: "Cheese Stick", size: "small meal", protein: 7),
            MealItem(name: "Glass of Milk", size: "medium meal", protein: 8),
            MealItem(name: "Chocolate Chip Cookie", size: "small meal", protein: 2)
        ]))
    }
}
