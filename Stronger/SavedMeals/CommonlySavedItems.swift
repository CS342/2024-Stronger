//
//  CommonlySavedItems.swift
//  Stronger
//
//  Created by Kevin Zhu on 2/7/24.
//

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
        MealItem(name: "Pear", size: "small", protein: 3),
    
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
                        // Action to replace the selected item and dismiss the view
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
                        }
                        .padding()
                        Divider()
                    }
                }
            }
        }
    }
}

//#Preview {
//    CommonlySavedItems()
//}