//
//  SelectSavedMeal.swift
//  Stronger
//
//  Created by Kevin Zhu on 2/5/24.
//

import SwiftUI

struct SelectSavedMeal: View {
    var body: some View {
        VStack {
            Text("Please select which saved meal to log")
                .font(.title2)
                .bold()
                .padding()
                .multilineTextAlignment(.center)
            
            Divider() // can make bolder like SelectNeworSaved
            
            // Vertically stacked buttons for meal options
            // Do we want to make the number of buttons variable?
            ForEach(1...5, id: \.self) { index in
                NavigationLink(destination: EditSavedMeal()) {
                    Text("\(index). Meal")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity) 
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange, lineWidth: 2))
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
            .navigationTitle("Select Saved Meal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
    
    #Preview {
        SelectSavedMeal()
    }

