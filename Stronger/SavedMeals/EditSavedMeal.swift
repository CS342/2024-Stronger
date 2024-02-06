//
//  EditSavedMeal.swift
//  Stronger
//
//  Created by Kevin Zhu on 2/5/24.
//

import SwiftUI

struct EditSavedMeal: View {
    // Placeholder data structure for meal items
    struct MealItem {
        var name: String
        var size: String
        var protein: Int
    }
    
    // Sample data for the list
    let mealItems: [MealItem] = [
        MealItem(name: "Placeholder 1", size: "large", protein: 20),
        MealItem(name: "Placeholder 2", size: "small", protein: 10),
        MealItem(name: "Placeholder 3", size: "large", protein: 20),
        MealItem(name: "Placeholder 4", size: "large", protein: 20),
        MealItem(name: "Placeholder 5", size: "large", protein: 20)
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            Text("Meal 1")
                .font(.title)
                .bold()
            Text("Click an item to edit or next to continue")
                .font(.subheadline)
                .padding(.bottom)
            
            Divider()
            
            // List of items
            ForEach(mealItems.indices, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(index + 1). \(mealItems[index].name)")
                            .bold()
                        Text("You indicated: \(mealItems[index].size) meal")
                        Text("[\(mealItems[index].protein)] grams of protein")
                    }
                    Spacer()
                    // Placeholder image
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 70, height: 70)
                        .overlay(Text("Food Image"))
                }
                .padding()
                Divider()
            }
            
            Spacer()
            NavigationLink(destination: MealReport()) {
                Text("Next")
                    .foregroundColor(.black)
                    .font(.headline) // can incease size
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange, lineWidth: 2))
            }
        }
        .padding()
        Spacer()
        
        .navigationTitle("Edit Saved Meal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    EditSavedMeal()
}
