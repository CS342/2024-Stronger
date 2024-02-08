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
    
    let commonItems: [MealItem] = [
        MealItem(name: "Salmon", size: "large portion", protein: 23, imageName: "salmon"),
        MealItem(name: "Rice", size: "small portion", protein: 4, imageName: "rice"),
        MealItem(name: "Turkey", size: "medium portion", protein: 15, imageName: "turkey"),
        MealItem(name: "Toast", size: "small portion", protein: 7, imageName: "toast"),
        MealItem(name: "Banana", size: "small portion", protein: 5, imageName: "banana"),
        MealItem(name: "Pear", size: "small portion", protein: 3, imageName: "pear")
    ]
    
    var body: some View {
        VStack {
            Text("Commonly Saved Items")
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(.black)
            Divider()
            ScrollView {
                ForEach(commonItems, id: \.id) { item in
                    Button(action: {
                        selectedItem = item
                        presentationMode.wrappedValue.dismiss()
                        presentationMode.wrappedValue.dismiss()
                        presentationMode.wrappedValue.dismiss()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .foregroundColor(.black)
                                    .font(.headline)
                                Text("\(item.size), [\(item.protein)] g of protein")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Image(item.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .accessibilityLabel("food name placeholder")
                        }
                        .padding()
                    }
                }
            }
        }
    }
}


// #Preview {
//     CommonlySavedItems()
// }
