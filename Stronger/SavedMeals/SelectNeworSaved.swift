// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
// Created by Kevin Zhu
import SwiftUI

struct SelectNeworSaved: View {
    var body: some View {
          NavigationView {
            VStack {
                Text("Are you logging a new or saved meal?")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                
                Divider().frame(height: 2).foregroundColor(.black).padding(.vertical)
                
                Spacer()
                
                NavigationLink(destination: ChatWindow()) {
                    Text("New Meal")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.orange, lineWidth: 2))
                }
                .padding(.bottom, 70)
                
                NavigationLink(destination: SelectSavedMeal()) {
                    Text("Saved Meal")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.orange, lineWidth: 2))
                }
                
                Spacer()
          }
              .navigationBarTitle("", displayMode: .inline)
              .navigationBarHidden(true)
        }
    }
}
// preview
struct SelectNeworSaved_Previews: PreviewProvider {
    static var previews: some View {
        SelectNeworSaved()
    }
}
