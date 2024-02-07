//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu

import SwiftUI

struct CommonlySavedItems: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedItem: MealItem
    
    // Sample array of common items
    let commonItems: [MealItem] = [
        MealItem(name: "Salmon", size: "large", protein: 23),
        MealItem(name: "Rice", size: "small", protein: 4),
        MealItem(name: "Turkey", size: "medium", protein: 15),
        MealItem(name: "Toast", size: "small", protein: 7),
        MealItem(name: "Banana", size: "small", protein: 5),
        MealItem(name: "Pear", size: "small", protein: 3)
    ]
    
    var body: some View {
        VStack {
            Text("Commonly Saved Items")
                .font(.title)
                .bold()
                .padding()
            
            Divider()
            
            ScrollView {
                ForEach(commonItems, id: \.id) { item in
                    Button(action: {
                        selectedItem = item
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text("\(item.size), [\(item.protein)] g of protein")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Image(systemName: "photo") // Placeholder for food image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .accessibilityLabel("food name placeholder")
                        }
                        .padding()
                        Divider()
                    }
                }
            }
        }
    }
}

// #Preview {
//     CommonlySavedItems()
// }
